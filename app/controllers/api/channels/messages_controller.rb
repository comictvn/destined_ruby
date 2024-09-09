class Api::Channels::MessagesController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index destroy]

  def index
    # ... existing code for index action ...
  end

  def destroy
    @message = Message.find(params[:id])
    raise ActiveRecord::RecordNotFound if @message.blank?

    authorize @message, policy_class: Api::Channels::MessagesPolicy

    if @message.destroy
      head :ok, message: I18n.t('common.200')
    else
      # ... existing code for handling destroy failure ...
    end
  end

  # ... any other existing code for this controller ...
end