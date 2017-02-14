class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable
  after_action :publish_comment, only: :create

  def new
    @comment = @commentable.comments.new
  end

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    @comment.save
  end

  private

  def publish_comment
    data = {
      commentable_id: @comment.commentable_id,
      commentable_type: @comment.commentable_type.underscore,
      comment: @comment
    }
    ActionCable.server.broadcast("comments_#{@question_id}", data)
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def set_commentable
    return if @comment.errors.any?
    if params[:question_id]
      @commentable = Question.find(params[:question_id])
      @question_id = @commentable.id
    elsif params[:answer_id]
      @commentable = Answer.find(params[:answer_id])
      @question_id = @commentable.question.id
    end
  end

end
