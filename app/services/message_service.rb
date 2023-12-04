class MessageService
  def initialize(params, _current_user = nil)
    @params = params
  end
  def create_message
    validate_params
    message = Message.new(content: @params[:content], user_id: @params[:user_id], chanel_id: @params[:chanel_id])
    if message.save
      message
    else
      raise ActiveRecord::RecordInvalid, message.errors.full_messages.join(", ")
    end
  end
  private
  def validate_params
    raise ActiveRecord::RecordInvalid, "The content is required." if @params[:content].blank?
    raise ActiveRecord::RecordInvalid, "The user is not found." unless User.exists?(@params[:user_id])
    raise ActiveRecord::RecordInvalid, "The chanel is not found." unless Chanel.exists?(@params[:chanel_id])
  end
end
