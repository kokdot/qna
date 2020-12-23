class LinkSerializer < ActiveModel::Serializer
  attributes :name, :url, :created_at, :updated_at
end
