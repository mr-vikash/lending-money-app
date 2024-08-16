class CalculateInterestJob < ApplicationJob
  queue_as :default

  def perform
    Loan.where(status: 'open').each do |loan|
      interest = (loan.amount * loan.interest_rate / 100) / (365 * 24 * 12) # Per 5 minutes
      loan.user.update(wallet_balance: loan.user.wallet_balance - interest)
      loan.admin.update(wallet_balance: loan.admin.wallet_balance + interest)
    end
  end
end
