class CommentsController < ApplicationController
  def new
    @comment = Comment.new
    @post_id = params[:post_id]
    @parent_comment_id = params[:parent_comment_id]

    render :new
  end

  def create
    @comment = current_user.comments.new(comment_params)

    if @comment.save
      redirect_to post_url(@comment.post)
    else
      flash[:errors] = "comment posting issue"
      redirect_to post_url(@comment.post)
    end
  end

  def show
    @comment = Comment.find(params[:id])

    render :show
  end

  private
  def comment_params
    params.require(:comment).permit(:content, :post_id, :parent_comment_id)
  end
end
