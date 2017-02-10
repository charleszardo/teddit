class UsersController < ApplicationController
  before_action :require_no_login, only: [:new, :create]

  def index
    @users = User.all

    render :index
  end

  def show
    @user = User.find(params[:id])

    render :show
  end

  def new
    @user = User.new

    render :new
  end

  def create
    p "OKAY CREATE IS HAPPENIN"
    @user = User.new(user_params)
    fail
    if @user.save
      # login_user!(@user)
      sign_up(@user)
      redirect_to root_url
    else
      flash[:errors] = @user.errors.full_messages
      render :new
    end
  end

  private
  def user_params
    params.require(:user).permit(:username, :email, :password)
  end
end
