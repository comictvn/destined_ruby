class Api::Chanels::MessagesController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index destroy]
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
    @messages = MessagesService.getMessages(chanel_id)
    if @messages.nil?
      render json: { error: 'No messages found for this chanel' }, status: :not_found
    else
      render json: { status: 200, messages: @messages }, status: :ok
    end
  end
  def destroy
    chanel = Chanel.find(params[:chanel_id])
    @message = chanel.messages.find(params[:id])
    raise ActiveRecord::RecordNotFound if @message.blank?
    authorize @message, policy_class: Api::Chanels::MessagesPolicy
    if @message.destroy
      render json: { message: I18n.t('common.200') }, status: :ok
    else
      head :unprocessable_entity
    end
  end
  private
  def is_integer?(str)
    str.to_i.to_s == str
  end
end
