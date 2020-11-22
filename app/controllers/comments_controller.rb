class CommentsController < ApplicationController
  before_action :authenticate_user!
  after_action :publish_comment, only: [:create]
  def create
    return unless ['Question', 'Answer'].include?(params[:resource])
    @resource = params[:resource].constantize.find(params[:resource_id])
    @comment = @resource.comments.new(comment_params)
    @comment.user = current_user
    @comment.save
    @id = @resource.class == Question ? @resource.id : @resource.question_id
  end

  private

  def publish_comment
    ActionCable.server.broadcast(
      "question_#{@id}",
      {
        type: 'comment',
        resource: @resource.class.to_s,
        body: @comment.body
      }
    )
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

end
