module ResponseHelper
  def success_response(message, data = nil, status = :ok)
    render json: { message: message, data: data }, status: status
  end
  def error_response(message, status = :unprocessable_entity)
    render json: { error: message }, status: status
  end
  def delete_message_response
    render json: { message: 'Message successfully deleted' }, status: 200
  end
end
