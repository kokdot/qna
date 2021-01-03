class Api::V1::AnswersController < Api::V1::BaseController
  before_action :load_answer, only: [:show, :update, :destroy]
  authorize_resource
  
  def index
    @question = Question.find(params[:question_id])
    @answers = Answer.where(question_id: @question)
    render json: @answers
  end

  def show
    render json: @answer
  end
  
  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.user = current_resource_owner
    if @answer.save
      render json: @answer
    else
      head 422
    end
  end

  def update
    if @answer.update(answer_params)
      render json: @answer
    else
      head 422
    end
  end

  def destroy
    @answer.destroy
    head :ok
  end

  private
  
  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url, :id, :_destroy])
  end
end
