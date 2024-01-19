module Api
  class MediaController < Api::BaseController
    before_action :doorkeeper_authorize!

    def create
      media_service = MediaService::Create.new(media_params)
      if media_service.execute
        render json: { id: media_service.media.id }, status: :created
      else
        render json: { errors: media_service.errors }, status: :unprocessable_entity
      end
    end

    private

    def media_params
      params.require(:media).permit(:article_id, :file_path, :media_type)
    end
  end
end
