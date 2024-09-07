class Api::LibrariesController < Api::BaseController
  rescue_from Exceptions::PublishingError, with: :handle_publishing_error

  def publish
    Library.publish_components_and_styles(
      components_params,
      styles_params,
      description_param,
      designer_id_param
    )
    render_response({ message: 'Components and styles were published successfully.' })
  end

  private

  def components_params
    params.require(:components).map do |component|
      component.permit(:id, :name)
    end
  end

  def styles_params
    params.require(:styles).map do |style|
      style.permit(:id, :name)
    end
  end

  def description_param
    params.require(:description)
  end

  def designer_id_param
    params.require(:designer_id)
  end

  def handle_publishing_error(exception)
    render_error('publishing_error', message: exception.message, status: :unprocessable_entity)
  end
end