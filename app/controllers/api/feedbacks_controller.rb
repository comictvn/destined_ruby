module Api
  class FeedbacksController < ApplicationController
    before_action :validate_params, only: [:create]
    def create
      begin
        feedback = Feedback.create!(feedback_params)
        render json: { message: 'Feedback created successfully' }, status: :ok
      rescue StandardError => e
        render json: { error: e.message }, status: :unprocessable_entity
      end
    end
    private
    def validate_params
      params.require(:feedback).permit(:content, :user_id)
    rescue ActionController::ParameterMissing => e
      render json: { error: e.message }, status: :bad_request
    end
    def feedback_params
      params.require(:feedback).permit(:content, :user_id)
    end
  end
end
