class Api::UsersController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index show articles]

  def index
    # inside service params are checked and whitelisted
    @users = UserService::Index.new(params.permit!, current_resource_owner).execute
    @total_pages = @users.total_pages
  end

  def show
    @user = User.find_by!('users.id = ?', params[:id])
    authorize @user, policy_class: Api::UsersPolicy
  end

  def articles
    return render json: { error: I18n.t('controller.users.missing_user_id') }, status: :bad_request unless params[:user_id].present?

    user = User.find_by(id: params[:user_id])
    return render json: { error: I18n.t('controller.users.user_not_found') }, status: :not_found unless user

    authorize user, policy_class: Api::UsersPolicy

    articles = Article.where(user_id: user.id)
    render json: articles, each_serializer: Api::ArticleSerializer
  end

  def authenticate
    username = params[:username]
    password = params[:password]
    begin
      token, expires_at = Auths::PhoneNumber.new.authenticate(username: username, password: password)
      render json: { token: token, expires_at: expires_at }, status: :ok
    rescue Exceptions::AuthenticationError
      render json: { error: 'Invalid credentials' }, status: :unauthorized
    end
  end

  # ... (any other actions that might exist in this controller)
  
  private
  # ... (any other private methods that might exist in this controller)
end
