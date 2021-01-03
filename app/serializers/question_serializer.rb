class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at, :short_title, :files
  has_many :answers, serializer: AnswersSerializer
  has_many :comments
  has_many :links
  has_many :files, serializer: FileSerializer
  belongs_to :user
  def short_title
    object.title.truncate(7)
  end
end
