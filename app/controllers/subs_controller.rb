class SubsController < ApplicationController
  # before_action :require_login, only: [:new, :create]
  # before_action :require_owner, only: [:edit, :update, :destroy]
  respond_to :json

  def index
    @subs = Sub.order(:title).page params[:page]

    render :index
  end

  def show
    @sub = Sub.find(params[:id])
    # @posts = @sub.posts
    # @posts = Post.get_scores(@posts)
    # @subscribed = false
    #
    # if current_user && current_user.subscribed?(@sub)
    #   @subscribed = true
    #   @subscription = Subscription.find_by(sub: @sub, user: current_user)
    # end

    render :show
  end

  def create
    @sub = Sub.new(sub_params)
    @sub.moderator = current_user

    if @sub.save
      render 'subs/show.json.jbuilder', status: 200
    else
      render json: {errors: @sub.errors}, status: 422
    end
  end

  # def update
  #   @sub = Sub.find(params[:id])
  #
  #   if @sub.update_attributes(sub_params)
  #     redirect_to sub_url(@sub)
  #   else
  #     flash[:errors] = "sub edit error"
  #     redirect_to edit_sub_url(@sub)
  #   end
  # end
  #

  #
  # def destroy
  #   @sub = Sub.find(params[:id])
  #
  #   if @sub.destroy
  #     redirect_to subs_url
  #   else
  #     flash[:errors] = "cannot delete sub"
  #     redirect_to sub_url(@sub)
  #   end
  # end

  private
  def sub_params
    params.require(:sub).permit(:title, :description)
  end
end
