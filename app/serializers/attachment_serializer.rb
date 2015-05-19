class AttachmentSerializer < ActiveModel::Serializer
  attributes :file_url

  def file_url
    object.file.url
  end
end
