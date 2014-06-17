class SessionsController < ApplicationController
  skip_before_action :authenticate_account!

  def new
    @account = Account.new
  end

  def create
    account = Account.authenticate(params[:account][:email], params[:account][:password])
    if account
      self.current_account = account
      flash[:notice] = "Welcome! you hace successfully signed in"
      redirect_back_or_default(root_path)
    else
      render "new"
    end
  end

  def destroy
    logout!
    flash[:notice] = "You have successfully logged out"
    redirect_to root_path
  end
end
