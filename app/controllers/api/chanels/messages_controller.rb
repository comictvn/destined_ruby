class Api::Chanels::MessagesController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index destroy]
  before_action :validate_params, only: [:destroy]
  def index
    chanel_id = params[:chanel_id]
    if chanel_id.nil? || !is_integer?(chanel_id)
      render json: { error: 'Wrong format' }, status: :bad_request
      return
    end
    chanel = Chanel.find_by(id: chanel_id)
    if chanel.nil?
      render json: { error: 'This chanel is not found' }, status: :not_found
      return
    end
    @messages = MessageService::Index.new(params.permit!, current_resource_owner).execute
    @total_pages = @messages.total_pages
    if @messages.nil?
      render json: { error: 'No messages found for this chanel' }, status: :not_found
    else
      render 'api/chanels/messages/index', status: :ok
    end
  end
  def destroy
    chanel = Chanel.find(params[:chanel_id])
    @message = chanel.messages.find(params[:id])
    raise ActiveRecord::RecordNotFound if @message.blank?
    authorize @message, policy_class: Api::Chanels::MessagesPolicy
    if @message.destroy
      render json: { status: 200, message: 'The message was successfully deleted.' }, status: :ok
    else
      head :unprocessable_entity
    end
  end
  private
  def validate_params
    chanel_id = params[:chanel_id]
    message_id = params[:id]
    unless chanel_id.to_i.to_s == chanel_id && message_id.to_i.to_s == message_id
      render json: { error: 'Wrong format' }, status: :unprocessable_entity
      return
    end
    unless Chanel.exists?(chanel_id) && Message.exists?(message_id)
      render json: { error: 'This chanel or message is not found' }, status: :unprocessable_entity
    end
  end
  def is_integer?(str)
    str.to_i.to_s == str
  end
end
