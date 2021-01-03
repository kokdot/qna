class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :load_question, only: [:show, :update, :destroy]
  authorize_resource
  
  def index
    @questions = Question.all
    render json: @questions
  end

  def show
    render json: @question
  end
  
  def create
    @question = current_resource_owner.questions.new(question_params)
    if @question.save
      render json: @question
    else
      head 422
    end
  end

  def update
    if @question.update(question_params)
      render json: @question
    else
      head 422
    end
  end

  def destroy
    @question.destroy
    head :ok
  end

  private
  
  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [], links_attributes: [:name, :url, :id, :_destroy],
                                      reward_attributes: [:name, :file])
  end
end
