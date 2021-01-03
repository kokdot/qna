class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at, :files
  has_many :comments
  has_many :links
  has_many :files, serializer: FileSerializer
end
