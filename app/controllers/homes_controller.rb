class HomesController < ApplicationController
  before_action :require_login, only: [:show]

  def show
    @user = current_user
    posts = current_user.subscribed_subs_posts
    @posts = Post.get_scores(@posts)
    render :show
  end
end
