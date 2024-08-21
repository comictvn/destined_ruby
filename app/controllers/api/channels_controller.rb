class Api::ChannelController < ApplicationController
  before_action :set_channel, only: [:show, :update, :destroy]

  # GET /api/channels
  def index
    @channels = Channel.all
    render json: @channels
  end

  # GET /api/channels/1
  def show
    render json: @channel
  end

  # POST /api/channels
  def create
    @channel = Channel.new(channel_params)
    authorize @channel, policy_class: Channels::MessagesPolicy

    if @channel.save
      render json: @channel, status: :created, location: @channel
    else
      render json: @channel.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/channels/1
  def update
    authorize @channel, policy_class: Channels::MessagesPolicy
    if @channel.update(channel_params)
      render json: @channel
    else
      render json: @channel.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/channels/1
  def destroy
    authorize @channel, policy_class: Channels::MessagesPolicy
    @channel.destroy
    head :no_content
  end

  private

  def set_channel
    @channel = Channel.find(params[:id])
  end

  def channel_params
    params.require(:channel).permit(:name, :description)
  end
end