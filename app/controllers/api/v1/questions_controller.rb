class Api::V1::QuestionsController < Api::V1::BaseController
  # before_action :load_question, only: [:show]
  def index
    @questions = Question.all
    render json: @questions
  end

  def show
    @question = Question.find(params[:id])
    # byebug
    render json: @question#, serializer: :question
  end

  private
  
  def load_question
    @question = Question.find(params[:id])
    # @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [], links_attributes: [:name, :url, :id, :_destroy],
                                      reward_attributes: [:name, :file])
  end
end
