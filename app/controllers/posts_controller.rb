class PostsController < ApplicationController
  before_action :require_login, only: [:new, :create]
  before_action :require_owner, only: [:edit, :update, :destroy]

  def new
    @post = Post.new

    render :new
  end

  def create
    @post = current_user.posts.new(post_params)

    if @post.save
      redirect_to sub_url(@post.subs.first)
    else
      flash[:errors] = "sub creation error"
      render :new
    end
  end

  def edit
    @post = Post.find(params[:id])

    render :edit
  end

  def update
    @post = Post.find(params[:id])

    if @post.update_attributes(post_params)
      redirect_to post_url(@post)
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
      redirect_to post_url(@post)
    end
  end

  def upvote
    vote(1)
  end

  def downvote
    vote(-1)
  end

  private
  def vote(value)
    vote_hash = { voter_id: current_user.id,
                  votable_id: params[:id],
                  votable_type: params[:controller].classify }

    vote = Vote.find_by(vote_hash)

    if vote
      vote.value = vote.value == value ? 0 : value
      vote.save
    else
      vote_hash[:value] = value
      Vote.create!(vote_hash)
    end

    redirect_to url_for(controller: params[:controller], id: params[:id], action: 'show')
  end

  def post_params
    params.require(:post).permit(:title, :url, :content, sub_ids: [])
  end
end
