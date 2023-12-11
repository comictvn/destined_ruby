module Api
  module Matches
    class FeedbacksController < Api::BaseController
      before_action :doorkeeper_authorize!, only: [:create]

      def create
        match = Match.find_by(id: params[:match_id])
        user = User.find_by(id: params[:user_id])

        if match.nil?
          return render json: { error: 'Match not found' }, status: :not_found
        end

        if user.nil?
          return render json: { error: 'Invalid user.' }, status: :bad_request
        end

        unless match.user_id == user.id || match.matcher1_id == user.id || match.matcher2_id == user.id
          return render json: { error: 'User not part of the match' }, status: :forbidden
        end

        unless params[:feedback_text].is_a?(String)
          return render json: { error: 'Invalid feedback.' }, status: :unprocessable_entity
        end

        feedback = Feedback.new(user_id: user.id, match_id: match.id, content: params[:feedback_text])

        if feedback.save
          render json: { status: 201, message: 'Feedback submitted successfully.' }, status: :created
        else
          render json: { errors: feedback.errors.full_messages }, status: :unprocessable_entity
        end
      rescue StandardError => e
        render json: { error: e.message }, status: :internal_server_error
      end
    end
  end
end
