# typed: ignore
module Api
  class BaseController < ActionController::API
    include OauthTokensConcern
    include ActionController::Cookies
    include Pundit::Authorization

    rescue_from ActiveRecord::RecordNotFound, with: :base_render_record_not_found
    rescue_from Exceptions::ChannelNotFoundError, with: :base_render_channel_not_found
    rescue_from Exceptions::InvalidParameterError, with: :base_render_invalid_parameter
    rescue_from ActiveRecord::RecordInvalid, with: :base_render_unprocessable_entity
    rescue_from Exceptions::AuthenticationError, with: :base_render_authentication_error
    rescue_from Exceptions::RecordNotFound, with: :base_render_custom_record_not_found
    rescue_from Exceptions::ForceUpdateAppVersionNotFound, with: :base_render_custom_record_not_found
    rescue_from Exceptions::ForceUpdateRequired, with: :base_render_force_update_required
    rescue_from ActiveRecord::RecordNotUnique, with: :base_render_record_not_unique
    rescue_from Pundit::NotAuthorizedError, with: :base_render_unauthorized_error
    rescue_from Exceptions::BadRequest, with: :base_render_bad_request
    rescue_from Exceptions::MessageNotFoundError, with: :base_render_message_not_found
    rescue_from Exceptions::UnauthorizedToDeleteMessageError, with: :base_render_unauthorized_to_delete_message

    def render_response(data, metadata: {}, **kwargs)
      render(json: { data: data, metadata: metadata }, **kwargs)
    end

    def render_error(error, message: nil, status: :bad_request, **kwargs)
      render(json: { error: error, message: message }, status: status, **kwargs)
    end

    def base_render_custom_record_not_found(_exception)
      render json: { message: I18n.t('common.errors.force_update_app_version_not_found') }, status: :not_found
    end

    private

    def base_render_record_not_found(_exception)
      render json: { message: I18n.t('common.404') }, status: :not_found
    end

    def base_render_force_update_required(_exception)
      render json: { message: I18n.t('common.force_update_app_versions.force_update_required') }, status: :upgrade_required
    end

    def base_render_bad_request(_exception)
      render json: { message: I18n.t('common.400') }, status: :bad_request
    end

    def base_render_unprocessable_entity(exception)
      render json: { message: exception.record.errors.full_messages }, status: :unprocessable_entity
    end

    def base_render_authentication_error(_exception)
      render json: { message: I18n.t('common.404') }, status: :not_found
    end

    def base_render_unauthorized_error(_exception)
      render json: { message: I18n.t('common.errors.unauthorized_error') }, status: :unauthorized
    end

    def base_render_record_not_unique
      render json: { message: I18n.t('common.errors.record_not_uniq_error') }, status: :forbidden
    end

    def base_render_channel_not_found(_exception)
      render json: { message: I18n.t('messages.list.channel_not_found') }, status: :not_found
    end

    def base_render_invalid_parameter(_exception)
      render json: { message: I18n.t('messages.list.channel_id_must_be_number') }, status: :bad_request
    end

    def base_render_message_not_found(_exception)
      render json: { message: I18n.t('common.errors.message_not_found') }, status: :not_found
    end

    def base_render_unauthorized_to_delete_message(_exception)
      render json: { message: I18n.t('common.errors.unauthorized_to_delete_message') }, status: :forbidden
    end

    def custom_token_initialize_values(resource, client)
      token = CustomAccessToken.create(
        application_id: client.id,
        resource_owner: resource,
        scopes: resource.class.name.pluralize.downcase,
        expires_in: Doorkeeper.configuration.access_token_expires_in.seconds
      )
      @access_token = token.token
      @token_type = 'Bearer'
      @expires_in = token.expires_in
      @refresh_token = token.refresh_token
      @resource_owner = resource.class.name
      @resource_id = resource.id
      @created_at = resource.created_at
      @refresh_token_expires_in = token.refresh_expires_in
      @scope = token.scopes
    end

    def current_resource_owner
      return super if defined?(super)
    end
  end
end
