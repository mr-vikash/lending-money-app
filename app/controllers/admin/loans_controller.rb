class Admin::LoansController < ApplicationController
  before_action :authenticate_admin!

  def update
    @loan = Loan.find(params[:id])
    case params[:commit]
    when 'Approve'
      approve_loan
    when 'Reject'
      reject_loan
    when 'Adjust'
      adjust_loan
    end
  end

  def index
    @loans = Loan.all
  end

  def show
    @loan = Loan.find(params[:id])
  end
  
  private

  def approve_loan
    flash[:notice] = "Loan approved successfully"
    @loan.update(status: 'approved')
    redirect_to admin_loan_path(@loan)
  end

  def reject_loan
    flash[:notice] = "Loan Reject successfully"
    @loan.update(status: 'rejected')
    redirect_to admin_loan_path(@loan)
  end

  def adjust_loan
    @loan.update(status: 'waiting_for_adjustment_acceptance', amount: params[:loan][:amount], interest_rate: params[:loan][:interest_rate])
    LoanAdjustment.create(loan: @loan, adjusted_amount: params[:loan][:amount], adjusted_interest_rate: params[:loan][:interest_rate])
    flash[:notice] = "Loan Adjusted successfully"
    redirect_to admin_loan_path(@loan)
  end

end


