class FileSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :url

  def url
    rails_blob_url(object, only_path: true)
  end
end
