class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_one :reward, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_many :votes, dependent: :destroy, as: :votable
  has_many_attached :files
  
  belongs_to :user

  scope :rating, ->(question) { Vote.where(votable_id: question).inject (0) { |sum, vote| sum + vote.votes} }

  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :reward, reject_if: :all_blank
  accepts_nested_attributes_for :votes, reject_if: :all_blank

  validates :title, :body, presence: true

end
