class UsersController < ApplicationController
  def index
    @users = User.all

    render :index
  end

  def new
    @user = User.new

    render :new
  end

  def create
    @user = User.create(user_params)

    if @user.save
      login_user!(user)
      redirect_to root_url
    else
      flash[:errors] = "user creation error"
      redirect_to :new
    end
  end

  private
  def user_params
    params.require(:user).permit(:username, :email, :password)
  end
end
