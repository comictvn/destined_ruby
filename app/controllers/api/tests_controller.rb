class Api::TestsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[update create]
  def update
    begin
      params.require(:id)
      params.require(:name)
      params.require(:status)
      raise ActionController::BadRequest.new("Wrong format") unless params[:id].is_a? Integer
      raise ActionController::BadRequest.new("The name is required.") if params[:name].blank?
      raise ActionController::BadRequest.new("You cannot input more 200 characters.") if params[:name].length > 200
      raise ActionController::BadRequest.new("Invalid status.") unless Test.statuses.include?(params[:status])
      @test = Test.find_by(id: params[:id])
      return render json: { error: 'This test is not found' }, status: :not_found unless @test
      authorize @test, policy_class: Api::TestsPolicy
      result = TestService::Update.new(@test, params[:name], params[:status], current_user).call
      if result.success?
        render json: { status: 200, test: @test }, status: :ok
      else
        render json: { error: result.errors.full_messages.join(', ') }, status: :unprocessable_entity
      end
    rescue ActionController::ParameterMissing => e
      render json: { error: e.message }, status: :bad_request
    rescue Pundit::NotAuthorizedError
      render json: { error: 'You are not authorized to perform this action' }, status: :forbidden
    rescue => e
      render json: { error: 'Something went wrong' }, status: :internal_server_error
    end
  end
  def create
    begin
      params.require(:name)
      params.require(:status)
      raise ActionController::BadRequest.new("The name is required.") if params[:name].blank?
      raise ActionController::BadRequest.new("You cannot input more 200 characters.") if params[:name].length > 200
      raise ActionController::BadRequest.new("Invalid status.") unless Test.statuses.include?(params[:status])
      result = TestService::Create.new(params[:name], params[:status], current_user).call
      if result.success?
        render json: result.data, status: :ok
      else
        render json: { error: result.errors.full_messages.join(', ') }, status: :unprocessable_entity
      end
    rescue ActionController::ParameterMissing => e
      render json: { error: e.message }, status: :bad_request
    rescue => e
      render json: { error: e.message }, status: :bad_request
    end
  end
end
