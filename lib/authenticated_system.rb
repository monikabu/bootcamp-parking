class AuthenticationError < StandardError; end

module AuthenticatedSystem
  def self.included(base)
    base.send :helper_method, :current_user, :current_account, :account_signed_in? if base.respond_to? :helper_method
  end

  protected

  # return current logged in person
  def current_user
    @current_user ||= current_account.owner if current_account
  end

  # return current logged in account
  def current_account
    @current_account ||= login_from_session
  end

  # set session account_id and current_account instance variable
  def current_account=(new_account)
    @current_account = new_account
    session[:account_id] = @current_account.try(:id)
  end

  # set current_account using session
  def login_from_session
    Account.find(session[:account_id]) if session[:account_id]
  end

  # check if user is logged in
  def account_signed_in?
    login_from_session
  end

  # return current login status (boolean value) or redirect to login form and save current user location
  def authenticate_account!
    if account_signed_in?
      return true
    else
      access_denied
    end
  end

  # save current user location and redirect to login form
  def access_denied
    store_location
    flash[:notice] = "You have to be logged in to access"
    redirect_to log_in_path
  end

  # save current user location in session[:return_to]
  def store_location
      session[:return_to] = request.fullpath
  end

  # redirect to stored URL or default path
  def redirect_back_or_default(default)
    redirect_to (session[:return_to] || default)
  end

  # clear session account_id and current_account variable
  def logout!
    self.current_account = nil
  end
end
