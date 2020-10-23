module HasVote
  extend ActiveSupport::Concern
  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def rating
    Vote.where(votable: self).sum(:value)
  end

end
