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
          # Merged error message to cover both cases
          return render json: { error: 'User not found or not part of the match.' }, status: :bad_request
        end

        # Merged user existence check to cover both cases
        unless match.users.exists?(id: user.id) || match.user_id == user.id || match.matcher1_id == user.id || match.matcher2_id == user.id
          return render json: { error: 'User not found or not part of the match.' }, status: :forbidden
        end

        # Merged feedback_text and comment validation
        feedback_text = params[:feedback_text] || params[:comment]
        if feedback_text.blank?
          return render json: { error: 'Feedback cannot be empty.' }, status: :unprocessable_entity
        end

        # Merged rating validation
        rating = params[:rating]
        unless rating.nil? || (rating.is_a?(Numeric) && rating.between?(1, 5))
          return render json: { error: 'Invalid or missing rating. Rating must be between 1 and 5.' }, status: :unprocessable_entity
        end

        # Merged feedback creation with conditional rating
        feedback = Feedback.new(
          user_id: user.id,
          match_id: match.id,
          content: feedback_text,
          rating: rating # This will be nil if not provided, which is acceptable if the model allows it
        )

        if feedback.save
          # Placeholder for future implementation if needed:
          # AdjustMatchingAlgorithmService.new(feedback).call

          # Merged success response, using :created for consistency with RESTful practices
          render json: { status: 201, message: 'Feedback submitted successfully.' }, status: :created
        else
          render json: { errors: feedback.errors.full_messages }, status: :unprocessable_entity
        end
      rescue ActiveRecord::RecordNotFound => e
        render json: { error: e.message }, status: :not_found
      rescue ActiveRecord::RecordInvalid => e
        render json: { error: e.message }, status: :unprocessable_entity
      rescue StandardError => e
        render json: { error: e.message }, status: :internal_server_error
      end
    end
  end
end
