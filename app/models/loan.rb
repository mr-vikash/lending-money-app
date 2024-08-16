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
end
