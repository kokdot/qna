class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_answer, only: [:update, :destroy, :best]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
    @number = 1
  end

  def update
    if current_user.author_of?(@answer)
      @answer.update(answer_params)
      @question = @answer.question
      @number = 1
    else
      redirect_to @answer.question, notice: "Your can't destroy not your answer."
    end
  end
  
  def destroy
    @question = @answer.question
    if current_user.author_of?(@answer)
      @answer.destroy
      redirect_to @question, notice: 'Your answer successfully destroyed.'
    else
      redirect_to @question, notice: "Your can't destroy not your answer."
    end
  end

  def best
    @answer.best_assign 
  end
  

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end
end
