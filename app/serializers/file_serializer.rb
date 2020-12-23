class FileSerializer < ActiveModel::Serializer
  attributes :name#, :url, :created_at, :updated_at

  def name
    object.filename.to_s
  end

  # def url
  #   url_for(object)
  # end
end
