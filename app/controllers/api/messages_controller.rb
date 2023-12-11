class Api::MessagesController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[create initiate_conversation]
  before_action :set_match, only: [:initiate_conversation]
  before_action :authenticate_sender, only: [:create]

  def create
    if valid_message_params?
      service = MessageCreationService.new
      result = service.create_message(
        match_id: @match.id,
        sender_id: message_params[:sender_id],
        receiver_id: recipient_id(@match, message_params[:sender_id].to_i),
        content: message_params[:content]
      )

      if result[:success]
        render json: { status: 201, message: "Message sent successfully." }, status: :created
      else
        render json: { error: result[:error] }, status: :unprocessable_entity
      end
    else
      render json: { error: "Invalid parameters" }, status: :bad_request
    end
  end

  def initiate_conversation
    ActiveRecord::Base.transaction do
      return render_error('Match not found', :not_found) unless @match

      unless [@match.matcher1_id, @match.matcher2_id].include?(message_params[:sender_id].to_i)
        return render_error('Sender not part of the match', :forbidden)
      end

      if message_params[:content].blank?
        return render_error('Message content cannot be empty', :bad_request)
      end

      @message = Message.new(match_id: @match.id, sender_id: message_params[:sender_id], content: message_params[:content])

      if @message.save
        MessageNotificationJob.perform_later(@message.id, recipient_id(@match, message_params[:sender_id].to_i))
        render json: { status: 201, message: @message.as_json }, status: :created
      else
        @error_object = @message.errors.messages
        render status: :unprocessable_entity
      end
    end
  end

  private

  def authenticate_sender
    set_match
    unless @match && [@match.matcher1_id, @match.matcher2_id].include?(message_params[:sender_id].to_i)
      render_error('Sender not part of the match', :forbidden)
    end
  end

  def valid_message_params?
    message_params[:sender_id].present? && message_params[:content].present?
  end

  def set_match
    @match = Match.find_by(id: params[:match_id])
    render_error('Match not found', :not_found) unless @match
  end

  def create_params
    params.require(:messages).permit(:content, :sender_id, :chanel_id, :images)
  end

  def message_params
    params.require(:message).permit(:sender_id, :content)
  end

  def recipient_id(match, sender_id)
    match.matcher1_id == sender_id ? match.matcher2_id : match.matcher1_id
  end

  def render_error(message, status)
    render json: { error: message }, status: status
  end

  def render_success(message)
    render json: { success: message }, status: :ok
  end
end
