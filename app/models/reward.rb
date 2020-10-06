class Reward < ApplicationRecord
  belongs_to :question
  belongs_to :answer, optional: true

  validates :name, presence: true

  has_one_attached :file
end
