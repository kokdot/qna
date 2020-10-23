module HasVote
  extend ActiveSupport::Concern
  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def rating(user)
    Vote.where(votable_id: self, user_id: user).sum(:value)
  end

end
