class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :logged_in?
  helper_method :current_user

  def login_user!(user)
    session[:session_token] = user.reset_session_token!
  end

  def logout_user!(user)
    session[:session_token] = nil
    user.reset_session_token!
  end

  def current_user
    session[:session_token] ? User.find_by_session_token(session[:session_token]) : nil
  end

  def logged_in?
    !current_user.nil?
  end
end
