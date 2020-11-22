class CommentsController < ApplicationController
  before_action :authenticate_user!
  after_action :publish_comment, only: [:create]
  def create
    @resource = params[:resource]
    if @resource == 'Question'
      @question = Question.find(params[:resource_id])
      @comment = @question.comments.new(comment_params)
      @comment.user = current_user
    elsif @resource == 'Answer'
      @answer = Answer.find(params[:resource_id])
      @question = @answer.question
      @comment = @answer.comments.new(comment_params)
      @comment.user = current_user
    end
    @comment.save
  end

  private

  def publish_comment
    ActionCable.server.broadcast(
      "question_#{@question.id}",
      {
        type: 'comment',
        resource: @resource,
        body: @comment.body
      }
    )
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

end
