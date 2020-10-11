class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  
  has_many :links, dependent: :destroy, as: :linkable
  has_many_attached :files
  has_one :reward

  accepts_nested_attributes_for :links, reject_if: :all_blank
  
  validates :body, presence: true

  scope :best_order, ->(question) { where(question_id: question).order(best: :desc) }
  
  def best_assign
    Answer.transaction do
      Answer.where(question_id: self.question).update_all(best: false)
      update!(best: true)
      self.reward = self.question.reward
    end
  end
end
