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

  def repay
    @loan = Loan.find(params[:id])
    total_repay_amount = @loan.amount + calculate_total_interest(@loan)
    if current_user.wallet_balance >= total_repay_amount
      current_user.update(wallet_balance: current_user.wallet_balance - total_repay_amount)
      @loan.admin.update(wallet_balance: @loan.admin.wallet_balance + total_repay_amount)
      @loan.update(status: 'closed')
    else
      partial_payment = current_user.wallet_balance
      current_user.update(wallet_balance: 0)
      @loan.admin.update(wallet_balance: @loan.admin.wallet_balance + partial_payment)
      @loan.update(status: 'closed')
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

  def calculate_total_interest(loan)
    # Logic to calculate total interest accrued on the loan
  end

  def loan_params
    params.require(:loan).permit(:amount, :interest_rate)
  end
end
