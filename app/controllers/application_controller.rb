class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_in) << :username
    devise_parameter_sanitizer.for(:sign_up) << :username
    devise_parameter_sanitizer.for(:account_update) << :username
  end

  private
  def require_login
    unless user_signed_in?
      redirect_to root_url
    end
  end

  def require_no_login
    if user_signed_in?
      redirect_to root_url
    end
  end

  def require_owner
    item = Object.const_get(controller_name.classify).find(params[:id])
    unless user_signed_in? && current_user.owns?(item)
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
