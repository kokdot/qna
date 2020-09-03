class AnswersController < ApplicationController
  before_action :authenticate_user!
  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.user_id = current_user.id
    if @answer.save
      redirect_to @question
    else
      redirect_to @question , notice: "Body can't be blank"
    end
  end
  
  def destroy
    @answer = Answer.find(params[:id])
    @question = @answer.question
    @answer.destroy
    redirect_to @question, notice: 'Your answer successfully destroyed.'

  end

  private
  def answer_params
    params.require(:answer).permit(:body)

  end
end
