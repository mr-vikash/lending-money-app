class User::LoansController < ApplicationController
  def new
    @loan = Loan.new
  end

  def create
    @loan = current_user.loans.build(loan_params.merge(admin: Admin.first, status: 'requested'))
    if @loan.save
      redirect_to user_loans_path, notice: 'Loan requested successfully.'
    else
      render :new
    end
  end

  private

  def loan_params
    params.require(:loan).permit(:amount, :interest_rate)
  end
end
