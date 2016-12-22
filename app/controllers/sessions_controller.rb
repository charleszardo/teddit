class SessionsController < ApplicationController
  def new
    @session = Session.new

    render :new
  end

  def create
    @session = Session.new(session_params)

    user = User.find_by_username_and_password(session_params[:username],
                                              session_params[:password])
    if user
      login_user!(user)
      redirect_to root_url
    else
      flash[:errors] = "invalid credentials"
      render :new
    end
  end

  def destroy
    if current_user
      logout_user!(current_user)
    else
      flash[:errors] = "no one's logged in..."
    end

    redirect_to root_url
  end

  private
  def session_params
    params.require(:user).permit(:username, :password)
  end
end
