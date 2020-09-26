class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_answer, only: [:update, :destroy, :best]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    if current_user.author_of?(@answer)
      @answer.update(answer_params)
      @question = @answer.question
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
    if current_user.author_of?(@answer.question)
      @answer.best_assign 
    end
  end
  

  private

  def answer_params
    params.require(:answer).permit(:body, files: [])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end
end
