class Api::MessagesController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[create initiate_conversation]

  def create
    @message = Message.new(create_params)

    authorize @message, policy_class: Api::MessagesPolicy

    return if @message.save

    @error_object = @message.errors.messages

    render status: :unprocessable_entity
  end

  def initiate_conversation
    ActiveRecord::Base.transaction do
      match = Match.find_by(id: params[:match_id])
      return render_error('Match not found', :not_found) unless match

      unless [match.matcher1_id, match.matcher2_id].include?(params[:sender_id].to_i)
        return render_error('Sender not part of the match', :forbidden)
      end

      @message = Message.new(match_id: params[:match_id], sender_id: params[:sender_id], content: params[:content])

      if @message.save
        MessageNotificationJob.perform_later(@message.id, recipient_id(match, params[:sender_id].to_i))
        render_success('Message sent')
      else
        @error_object = @message.errors.messages
        render status: :unprocessable_entity
      end
    end
  end

  private

  def create_params
    params.require(:messages).permit(:content, :sender_id, :chanel_id, :images)
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
