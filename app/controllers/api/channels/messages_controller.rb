class Api::Channels::MessagesController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index destroy]

  def index
    # ... index action code ...
  end

  def destroy
    authorize @message, policy_class: Api::Channels::MessagesPolicy

    if @message.destroy
      head :ok, message: I18n.t('common.200')
    else
      # ... handle destroy failure ...
    end
  end
end