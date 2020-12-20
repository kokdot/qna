class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  after_action :publish_question, only: [:create]
  authorize_resource

  def index
    @questions = Question.all
  end

  def show
    @answers = @question.answers
    @answer = Answer.new
    @vote = Vote.new
    @answer.links.new
    @comment = @answer.comments.new
    @answers = @answers.order(best: :desc)
  end
  
  def new
    @question = Question.new
    @question.links.new # .build
    @question.reward = Reward.new
  end
  
  def edit
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user
    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    # if current_user.author_of?(@question)
      if @question.update(question_params)
        redirect_to @question
      end
    # else
      # redirect_to @question
    # end
  end
  
  def destroy
    # if current_user.author_of?(@question)
      @question.destroy
      redirect_to questions_path, notice: 'Your question successfully destroyed.'
    # else
      # redirect_to @question, notice: "Your can't destroy not your question."
    # end
  end
  
  private
  
  def load_question
    @question = Question.with_attached_files.find(params[:id])
    gon.question_id = @question.id
    gon.user_id = current_user.id if current_user
    gon.question_owner_id = @question.user_id
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [], links_attributes: [:name, :url, :id, :_destroy],
                                      reward_attributes: [:name, :file])
  end

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast 'questions',
      { id: @question.id, title: @question.title, body: @question.body }
  end
end
