class CommentsController < ApplicationController
  def new
    @comment = Comment.new
    @post_id = params[:post_id]

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

  private
  def comment_params
    params.require(:comment).permit(:content, :post_id)
  end
end
