class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  def best_assign
    @question = self.question
    Answer.where(question_id: self.question).update_all(best: false)
    self.best = true
    self.save
    Answer.where(question_id: @question).order(best: :desc)
  end

end
