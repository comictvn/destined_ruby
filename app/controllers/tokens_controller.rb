# frozen_string_literal: true

class TokensController < Doorkeeper::TokensController
  # callback
  before_action :validate_resource_owner

  # methods

  def validate_resource_owner
    return if resource_owner.blank?

    if resource_owner_locked?
      render_unauthorized('common.errors.token.locked')
    elsif !resource_owner_confirmed?
      render_unauthorized('common.errors.token.inactive')
    end
  end
  

  def resource_owner
    @resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  def resource_owner_confirmed?
    resource_owner && resource_owner.confirmed?
  end

  def create
    token = Doorkeeper::AccessToken.create(resource_owner_id: resource_owner.id, application_id: doorkeeper_token.application_id)
    render json: {
      access_token: token.token,
      token_type: 'Bearer',
      expires_in: token.expires_in.to_i,
      refresh_token: token.refresh_token,
      scope: token.scopes.join(' ')
    }
  end

  private

  def resource_owner_confirmed?
    if
  end

  def resource_owner_locked?
    false
  end


  def render_unauthorized(error_key)
    render json: {
      error: I18n.t(error_key),
      message: I18n.t(error_key)
    }, status: :unauthorized
  end

  def resource_owner
    return nil if action_name == 'revoke'

    return unless authorize_response.respond_to?(:token)

    authorize_response&.token&.resource_owner
  end

  def resource_owner_locked?
    resource_owner.access_locked?
  end

  def resource_owner_confirmed?
    return resource_owner.confirmed? if %w[User].include?(resource_owner.class.name)

    true
  end
end
