class User::LoansController < ApplicationController
  before_action :authenticate_user!

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

  def show
    @loan = Loan.find(params[:id])
  end

  def index
    @loans = Loan.all
  end

  def update
    @loan = Loan.find(params[:id])
    case params[:commit]
    when 'Accept'
      accept_adjustment
    when 'Reject'
      reject_loan
    when 'Confirm'
      confirm_loan
    when 'Request Readjustment'
      request_readjustment
    when 'Request adjustment'
      request_adjustment
    when 'Repay Loan' 
      repay
    end
  end

  

  private

  def repay
    @loan = Loan.find(params[:id])
    total_repay_amount = @loan.amount
    if current_user.wallet_balance >= total_repay_amount
      current_user.update(wallet_balance: current_user.wallet_balance - total_repay_amount)
      @loan.admin.update(wallet_balance: @loan.admin.wallet_balance + total_repay_amount)
      @loan.update(status: 'closed')
      flash[:notice] = "Money tranferred to admin account"
      redirect_to user_loan_path(@loan)
    else
      partial_payment = current_user.wallet_balance
      current_user.update(wallet_balance: 0)
      @loan.admin.update(wallet_balance: @loan.admin.wallet_balance + partial_payment)
      @loan.update(status: 'closed')
      flash[:notice] = "Money tranferred to admin account"
      redirect_to user_loan_path(@loan)
    end
  end

  def confirm_loan
    @loan = Loan.find(params[:id])
    if @loan.status == 'approved'
      if @loan.update(status: 'open')
        current_user.wallet_balance += @loan.amount
        @loan.admin.wallet_balance -= @loan.amount
        if current_user.save && @loan.admin.save
          redirect_to user_loan_path(@loan), notice: 'Loan confirmed and funds transferred to your wallet.'
        else
          redirect_to user_loan_path(@loan), alert: 'Unable to confirm the loan due to wallet update error.'
        end
      else
        redirect_to user_loan_path(@loan), alert: 'Unable to confirm the loan.'
      end
    else
      redirect_to user_loan_path(@loan), alert: 'Loan must be in approved status to confirm.'
    end
  end
  
  def accept_adjustment
    @loan.update(status: 'open')
    update_wallets
  end

  def reject_loan
    if @loan.update(status: 'rejected')
      redirect_to user_loans_path, notice: 'Loan rejected successfully.'
    else
      redirect_to user_loan_path(@loan), alert: 'Unable to reject the loan.'
    end
  end

  def request_adjustment
    if @loan.update(status: 'readjustment_requested')
      redirect_to user_loan_path(@loan), notice: 'Loan adjustment request sent to the admin.'
    else
      redirect_to user_loan_path(@loan), alert: 'Unable to request a loan adjustment.'
    end
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
