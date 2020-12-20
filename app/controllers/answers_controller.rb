class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_answer, only: [:update, :destroy, :best]
  after_action :publish_answer, only: [:create]
  authorize_resource

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    # if current_user.author_of?(@answer)
      @answer.update(answer_params)
      @question = @answer.question
    # else
      # redirect_to @answer.question, notice: "Your can't destroy not your answer."
    # end
  end
  
  def destroy
    @question = @answer.question
    # if current_user.author_of?(@answer)
      @answer.destroy
      redirect_to @question, notice: 'Your answer successfully destroyed.'
    # else
      # redirect_to @question, notice: "Your can't destroy not your answer."
    # end
  end

  def best
    # if current_user.author_of?(@answer.question)
      @answer.best_assign 
    # end
  end
  

  private

  def publish_answer
    return if @answer.errors.any?
    gon.question_id = @answer.question_id
    gon.user_id = current_user.id
    gon.question_owner_id = @answer.question.user_id
    @files = []
    @answer.files.each do |file|
      @files << {name: file.filename.to_s, url: url_for(file), id: file.id}
    end
    ActionCable.server.broadcast(
      "question_#{@question.id}",
      {
        type: 'answer',
        answer: @answer,
        files: @files,
        links: @answer.links,
        rating: @answer.rating()
      }
    )
  end
  
  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url, :id, :_destroy])
  end
end
