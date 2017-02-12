class UsersController < ApplicationController
  # before_action :require_no_login, only: [:new, :create]

  def show
    @user = User.find(params[:id])

    render :show
  end
end
