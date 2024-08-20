class Loan < ApplicationRecord
  belongs_to :user
  belongs_to :admin
  has_many :loan_adjustments
  validates :amount, :interest_rate, numericality: { greater_than: 0 }
  validates :status, inclusion: { in: %w[requested approved open closed rejected waiting_for_adjustment_acceptance readjustment_requested] }

  def adjustment_history
    loan_adjustments.map do |adj|
      "Adjusted Amount: #{adj.adjusted_amount}, Adjusted Interest Rate: #{adj.adjusted_interest_rate}"
    end
  end


  def check_loan_repayment
    if user.wallet_balance < amount
      pay_partially
      self.status = 'closed'
      self.save
    end
  end

  def repay_loan
    if user.wallet_balance >= amount
      pay_in_full
    else
      pay_partially
    end
  end

  private

  def pay_partially
    partial_payment = user.wallet_balance
    user.update(wallet_balance: 0)
    admin.update(wallet_balance: admin.wallet_balance + partial_payment)
  end

  def pay_in_full
    user.update(wallet_balance: user.wallet_balance - amount)
    admin.update(wallet_balance: admin.wallet_balance + amount)
  end
end
