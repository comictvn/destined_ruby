class UserValidator < ActiveModel::Validator
  class ValidationError < StandardError; end
  def validate(record)
    validate_username(record)
    validate_email(record)
    validate_password(record)
    validate_password_confirmation(record)
  end
  private
  def validate_username(record)
    if record.username.blank?
      record.errors.add(:username, "Username can't be blank")
    elsif record.username.length > 50
      record.errors.add(:username, "Username cannot exceed 50 characters.")
    end
  end
  def validate_email(record)
    if record.email.blank?
      record.errors.add(:email, "The email is required.")
    elsif record.email !~ URI::MailTo::EMAIL_REGEXP
      record.errors.add(:email, "Invalid email format.")
    elsif User.exists?(email: record.email)
      record.errors.add(:email, "The email is already in use.")
    end
  end
  def validate_password(record)
    if record.password.blank?
      record.errors.add(:password, "The password is required.")
    elsif record.password.length < 8
      record.errors.add(:password, "Password must be at least 8 characters.")
    end
  end
  def validate_password_confirmation(record)
    if record.password_confirmation.blank?
      record.errors.add(:password_confirmation, "Password confirmation is required.")
    elsif record.password != record.password_confirmation
      record.errors.add(:password_confirmation, "Password confirmation does not match password.")
    end
  end
end
