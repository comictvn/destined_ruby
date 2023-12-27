class Api::MessagesController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[create filter_and_paginate_messages]

  def create
    @message = Message.new(create_params)

    authorize @message, policy_class: Api::MessagesPolicy

    return if @message.save

    @error_object = @message.errors.messages

    render status: :unprocessable_entity
  end

  def filter_and_paginate_messages
    messages_query = Message.all
    messages_query = messages_query.where(sender_id: params[:sender_id]) if params[:sender_id].present?
    messages_query = messages_query.where(channel_id: params[:channel_id]) if params[:channel_id].present?
    messages_query = messages_query.where("content LIKE ?", "%#{params[:content]}%") if params[:content].present?
    messages_query = messages_query.order(created_at: :desc)

    @messages = messages_query.paginate(page: params[:page], per_page: params[:per_page] || 20)

    render json: {
      messages: @messages,
      total_pages: @messages.total_pages,
      current_page: @messages.current_page
    }
  end

  private

  def create_params
    params.require(:messages).permit(:content, :sender_id, :channel_id, :images)
  end
end
