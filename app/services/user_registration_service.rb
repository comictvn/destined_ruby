class UserRegistrationService < BaseService
  def initialize(user_params)
    @user_params = user_params
  end
  def register
    validate_input
    check_email
    user = create_user
    send_confirmation_email(user)
    user
  rescue ActiveRecord::RecordNotUnique => e
    raise ActiveRecord::RecordNotUnique, "Email already registered"
  rescue => e
    raise "An error occurred while creating the user: #{e.message}"
  end
  private
  def validate_input
    validator = UserRegistrationValidator.new(@user_params)
    errors = validator.validate
    raise ActiveRecord::RecordInvalid, errors.full_messages.join(", ") unless errors.empty?
  end
  def check_email
    user = User.find_by(email: @user_params[:email])
    raise ActiveRecord::RecordNotUnique, "Email already registered" if user
  end
  def create_user
    user = User.new(@user_params)
    user.save!
    user
  end
  def send_confirmation_email(user)
    UserMailer.confirmation_email(user).deliver_now
  end
end
