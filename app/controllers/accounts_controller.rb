class AccountsController < ApplicationController
  skip_before_action :authenticate_account!

  def new
    @account = Account.new
  end
  
  def create
    @account = Account.new(account_params)
    if @account.save
      self.current_account = @account
      flash[:notice] = "Your account was successfully created"
      redirect_back_or_default(root_path)
    else
      render "new"
    end 
  end

  private
  def account_params
    params.require(:account).permit(:email, :password, :password_confirmation )
  end
end
