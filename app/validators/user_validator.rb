class UserValidator < ActiveModel::Validator
  class ValidationError < StandardError; end
  def validate(record)
    validate_name(record)
    validate_email(record)
    validate_password(record)
  end
  def validate_user_params(params)
    validate_name(params)
    validate_email(params)
    validate_password(params)
  end
  private
  def validate_name(params)
    if params[:name].blank?
      raise ValidationError, "Name can't be blank"
    elsif params[:name].length > 50
      raise ValidationError, "You cannot input more 50 characters."
    end
  end
  def validate_email(params)
    if params[:email].blank?
      raise ValidationError, "The email is required."
    elsif params[:email] !~ URI::MailTo::EMAIL_REGEXP
      raise ValidationError, "Wrong email format."
    elsif User.exists?(email: params[:email])
      raise ValidationError, "The email is already in use."
    end
  end
  def validate_password(params)
    if params[:password].blank?
      raise ValidationError, "The password is required."
    elsif params[:password].length < 8
      raise ValidationError, "Password must be at least 8 characters."
    end
  end
end
