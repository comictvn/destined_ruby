class Api::Channels::MessagesController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index destroy]

  def index
    # Code for index action
  end

  def destroy
    authorize @message, policy_class: Api::Channels::MessagesPolicy

    if @message.destroy
      head :ok, message: I18n.t('common.200')
    else
      # Code to handle failure
    end
  end
end