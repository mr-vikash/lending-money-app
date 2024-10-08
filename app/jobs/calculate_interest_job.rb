class CalculateInterestJob < ApplicationJob
  queue_as :default

  def perform
    Loan.where(status: 'open').each do |loan|
      interest = (loan.amount * loan.interest_rate / 100)
      loan.update(amount: loan.amount + interest)
      loan.check_loan_repayment
    end
  end
end
