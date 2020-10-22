class VotesController < ApplicationController
  before_action :authenticate_user!

  def votes_up
    @type = params[:type]
    if @type == 'question'
      @votable = Question.find(params[:id])
    else
      @votable = Answer.find(params[:id])
    end
    @vote = Vote.where(user_id: current_user, votable_id: @votable).first
    respond_to do |format|
      if @vote || current_user.author_of?(@votable)
        format.json { render json: { mes: 'You already vote or this is yours' }, status: :unprocessable_entity }
      else
        @vote = Vote.new
        @vote.votes = 1
        @vote.votable = @votable
        @vote.user = current_user
        if @vote.save
          format.json { render json: {sum: Question.rating(@votable)} }
        else
          format.json { render json: { mes: 'You already vote or this is yours' }, status: :unprocessable_entity }
        end
      end
    end
  end

  def votes_down
    @type = params[:type]
    if @type == 'question'
      @votable = Question.find(params[:id])
    else
      @votable = Answer.find(params[:id])
    end
    @vote = Vote.where(user_id: current_user, votable_id: @votable).first
    respond_to do |format|
      if @vote || current_user.author_of?(@votable)
        format.json { render json: { mes: 'You already vote or this is yours' }, status: :unprocessable_entity }
      else
        @vote = Vote.new
        @vote.votes = -1
        @vote.votable = @votable
        @vote.user = current_user
        if @vote.save
          format.json { render json: {sum: Question.rating(@votable)} }
        else
          format.json { render json: { mes: 'You already vote or this is yours' }, status: :unprocessable_entity }
        end
      end
    end
  end

  def votes_cancel
    @type = params[:type]
    if @type == 'question'
      @votable = Question.find(params[:id])
    else
      @votable = Answer.find(params[:id])
    end
    # @question = Question.find(params[:id])
    @vote = Vote.where(user_id: current_user, votable_id: @votable).last
    respond_to do |format|
      if @vote
        @vote.destroy
        format.json { render json: {sum: Question.rating(@question)} }
      else
        format.json { render json: { nothing: true }, status: :unprocessable_entity }
      end
    end
  end

  # def create
  #   @question = Question.find(params[:id])
  #   @vote = Vote.where(user_id: current_user, votable_id: @question).first
  #   respond_to do |format|
  #     if @vote || current_user.author_of?(@question)
  #       format.json { render json: { mes: 'You already vote or this is your question' }, status: :unprocessable_entity }
  #     else
  #       @vote = Vote.new
  #       if params[:vote][:vote] == 'for'
  #         @vote.votes = 1
  #       else 
  #         @vote.votes = -1
  #       end
  #       @vote.votable = @question
  #       @vote.user = current_user
  #       if @vote.save
  #         format.json { render json: {sum: Question.rating(@question)} }
  #       else
  #         format.json { render json: { mes: 'You already vote or this is your question' }, status: :unprocessable_entity }
  #       end
  #     end
  #   end
  # end

  # def destroy
  #   @question = Question.find(params[:id])
  #   @vote = Vote.where(user_id: current_user, votable_id: @question).last
  #   respond_to do |format|
  #     if @vote
  #       @vote.destroy
  #       format.json { render json: {sum: Question.rating(@question)} }
  #     else
  #       format.json { render json: { nothing: true }, status: :unprocessable_entity }
  #     end
  #   end
  # end
end
