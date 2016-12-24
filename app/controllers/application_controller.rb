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

  private
  def require_login
    unless current_user
      redirect_to root_url
    end
  end

  def require_no_login
    if current_user
      redirect_to root_url
    end
  end

  def require_owner
    item = Object.const_get(controller_name.classify).find(params[:id])
    unless item.is_owner?(current_user)
      redirect_to root_url
    end
  end

  def vote(value)
    vote_hash = { voter_id: current_user.id,
                  votable_id: params[:id],
                  votable_type: params[:controller].classify }

    vote = Vote.find_by(vote_hash)
    vote ? update_vote(vote, value) : new_vote(vote_hash, value)
  end

  def update_vote(vote, value)
    vote.value = vote.value == value ? 0 : value
    vote.save
  end

  def new_vote(vote_hash, value)
    vote_hash[:value] = value
    Vote.create!(vote_hash)
  end
end
