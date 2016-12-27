class SubsController < ApplicationController
  before_action :require_login, only: [:new, :create]
  before_action :require_owner, only: [:edit, :update, :destroy]

  def index
    @subs = Sub.order(:title).page params[:page]

    render :index
  end

  def new
    @sub = Sub.new

    render :new
  end

  def create
    @sub = Sub.new(sub_params)
    @sub.moderator = current_user

    if @sub.save
      redirect_to sub_url(@sub)
    else
      flash[:errors] = "sub creation error"
      redirect_to new_sub_url
    end
  end

  def edit
    @sub = Sub.find(params[:id])

    render :edit
  end

  def update
    @sub = Sub.find(params[:id])

    if @sub.update_attributes(sub_params)
      redirect_to sub_url(@sub)
    else
      flash[:errors] = "sub edit error"
      redirect_to edit_sub_url(@sub)
    end
  end

  def show
    @sub = Sub.find(params[:id])
    @posts = Post.get_scores(@sub.posts)

    render :show
  end

  def destroy
    @sub = Sub.find(params[:id])

    if @sub.destroy
      redirect_to subs_url
    else
      flash[:errors] = "cannot delete sub"
      redirect_to sub_url(@sub)
    end
  end

  private
  def sub_params
    params.require(:sub).permit(:title, :description)
  end
end
