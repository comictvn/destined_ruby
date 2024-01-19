# rubocop:disable Style/ClassAndModuleChildren
class MediaService::Create
  def execute(article_id, file_path, media_type)
    raise ArgumentError, 'Invalid article ID format.' unless article_id.is_a?(Integer)
    raise ArgumentError, 'Article not found.' unless Article.exists?(article_id)
    raise ArgumentError, 'Invalid file path or URL.' unless valid_file_path_or_url?(file_path)
    raise ArgumentError, 'Invalid media type.' unless ['image', 'video', 'audio'].include?(media_type)

    media = Media.new(article_id: article_id, file_path: file_path, media_type: media_type)

    if media.save
      {
        status: 200,
        message: "Media content inserted successfully.",
        media: media.as_json(only: [:id, :article_id, :file_path, :media_type, :created_at])
      }
    else
      raise StandardError, media.errors.full_messages.to_sentence
    end
  end

  private

  def valid_file_path_or_url?(file_path)
    uri = URI.parse(file_path)
    uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS) || File.exist?(file_path)
  rescue URI::InvalidURIError
    false
  end
end
# rubocop:enable Style/ClassAndModuleChildren
