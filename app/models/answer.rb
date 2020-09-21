class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  scope :best_order, ->(question) { where(question_id: question).order(best: :desc) }
  
  def best_assign
    Answer.transaction do
      Answer.where(question_id: self.question).update_all(best: false)
      update!(best: true)
    end
  end
end
