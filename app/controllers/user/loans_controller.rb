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

  def update
    @loan = Loan.find(params[:id])
    case params[:commit]
    when 'Accept'
      accept_adjustment
    when 'Reject'
      reject_loan
    when 'Request Readjustment'
      request_readjustment
    end
  end

  private
  
  def accept_adjustment
    @loan.update(status: 'open')
    update_wallets
  end

  def reject_loan
    @loan.update(status: 'rejected')
  end

  def request_readjustment
    @loan.update(status: 'readjustment_requested')
  end

  def update_wallets
    @loan.user.update(wallet_balance: @loan.user.wallet_balance + @loan.amount)
    @loan.admin.update(wallet_balance: @loan.admin.wallet_balance - @loan.amount)
  end

  def loan_params
    params.require(:loan).permit(:amount, :interest_rate)
  end
end
