class Api::MessagesController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[create]
  before_action :set_match, only: [:create]
  before_action :authenticate_sender, only: [:create]
  before_action :validate_users, only: [:create]

  def create
    if valid_message_params?
      service = MessageCreationService.new
      result = service.create_message(
        match_id: @match.id,
        sender_id: message_params[:sender_id],
        receiver_id: message_params[:receiver_id],
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

  private

  def authenticate_sender
    set_match
    unless @match && [@match.matcher1_id, @match.matcher2_id].include?(message_params[:sender_id].to_i)
      render_error('Sender not part of the match', :forbidden)
    end
  end

  def validate_users
    sender = User.find_by(id: message_params[:sender_id])
    receiver = User.find_by(id: message_params[:receiver_id])
    unless sender && receiver && [@match.matcher1_id, @match.matcher2_id].include?(sender.id) && [@match.matcher1_id, @match.matcher2_id].include?(receiver.id)
      render_error('User not found or not part of the match', :not_found)
    end
  end

  def valid_message_params?
    message_params[:match_id].present? && message_params[:sender_id].present? && message_params[:receiver_id].present? && message_params[:content].present?
  end

  def set_match
    @match = Match.find_by(id: message_params[:match_id])
    render_error('Match not found', :not_found) unless @match
  end

  def message_params
    params.require(:message).permit(:match_id, :sender_id, :receiver_id, :content)
  end

  def render_error(message, status)
    render json: { error: message }, status: status
  end

  def render_success(message)
    render json: { success: message }, status: :ok
  end
end
