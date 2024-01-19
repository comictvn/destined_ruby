# rubocop:disable Style/ClassAndModuleChildren
class MediaService::Create
  def execute(article_id, file_path, media_type)
    raise ArgumentError, 'article_id is required' if article_id.blank?
    raise ArgumentError, 'file_path is required' if file_path.blank?
    raise ArgumentError, 'media_type is not valid' unless ['image', 'video', 'audio'].include?(media_type)

    media = Media.new(article_id: article_id, file_path: file_path, media_type: media_type)

    if media.save
      media.id
    else
      raise StandardError, media.errors.full_messages.to_sentence
    end
  end
end
# rubocop:enable Style/ClassAndModuleChildren
