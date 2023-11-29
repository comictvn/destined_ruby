module Api
  class FeedbacksController < ApplicationController
    before_action :validate_params, only: [:create]
    def create
      begin
        feedback = FeedbackService.new.create_feedback(params[:id], params[:feedback])
        render json: { message: 'Success' }, status: :ok
      rescue StandardError => e
        render json: { error: e.message }, status: :unprocessable_entity
      end
    end
    private
    def validate_params
      params.require(:id)
      params.require(:feedback)
    rescue ActionController::ParameterMissing => e
      render json: { error: e.message }, status: :bad_request
    end
  end
end
