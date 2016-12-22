class PostsController < ApplicationController
  before_action :require_login, only: [:new, :create]
  before_action :require_owner, only: [:edit, :update, :destroy]

  def new
    @post = Post.new

    render :new
  end

  def create
    @post = Post.new(post_params)
    @post.author = current_user

    if @post.save
      redirect_to sub_url(@post.sub)
    else
      flash[:errors] = "sub creation error"
      redirect_to new_sub_url
    end
  end

  def edit
    @post = Post.find(params[:id])

    render :edit
  end

  def update
    @post = Post.find(params[:id])

    if @post.update_attributes(post_params)
      redirect_to sub_url(@post.sub)
    else
      flash[:errors] = "post edit error"
      redirect_to edit_post_url(@post)
    end
  end

  def show
    @post = Post.find(params[:id])

    render :show
  end

  def destroy
    @post = Post.find(params[:id])

    if @post.destroy
      redirect_to subs_url
    else
      flash[:errors] = "cannot delete sub"
      redirect_to sub_url(@post.sub)
    end
  end

  private
  def post_params
    params.require(:post).permit(:title, :url, :content)
  end
end