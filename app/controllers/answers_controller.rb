class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_answer, only: [:update, :destroy, :best]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.user_id = current_user.id
    @answer.save
    @number = 1
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
    @number = 1
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
    @question = @answer.question
    @answers = Answer.where(question_id: @question)
    @answers.each do |answer| 
      answer.best = 'a'
      answer.save 
    end
    @answer.best = 'b'
    @answer.save
    @answers = @answers.order(best: :desc)
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end
end
