class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :load_votable
  # authorize_resource

  def votes_up
    respond_to do |format|
      if @vote || !(can? :votes_up, @votable)
      # if @vote || current_user.author_of?(@votable)
        format.json { render json: { mes: 'You already vote or this is yours' }, status: :unprocessable_entity }
      else
        @vote = @votable.votes.new(value: 1, user: current_user)
        if @vote.save
          format.json { render json: { sum: @votable.rating() } }
        else
          format.json { render json: { mes: 'You already vote or this is yours' }, status: :unprocessable_entity }
        end
      end
    end
  end

  def votes_down
    respond_to do |format|
      if @vote || !(can? :votes_up, @votable)
      # if @vote || current_user.author_of?(@votable)
        format.json { render json: { mes: 'You already vote or this is yours' }, status: :unprocessable_entity }
      else
        @vote = @votable.votes.new(value: -1, user: current_user)
        if @vote.save
          format.json { render json: { sum: @votable.rating() } }
        else
          format.json { render json: { mes: 'You already vote or this is yours' }, status: :unprocessable_entity }
        end
      end
    end
  end

  def votes_cancel
    respond_to do |format|
      if @vote
        @vote.destroy
        format.json { render json: { sum: @votable.rating() } }
      else
        format.json { render json: { nothing: true }, status: :unprocessable_entity }
      end
    end
  end

  private

  def load_votable
    @type = params[:type]
    if @type == 'question'
      @votable = Question.find(params[:id])
    else
      @votable = Answer.find(params[:id])
    end
    @vote = Vote.where(user_id: current_user, votable: @votable).first
  end
end
