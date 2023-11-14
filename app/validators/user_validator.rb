class UserValidator < ActiveModel::Validator
  def validate(record)
    if record.email.blank?
      record.errors.add(:email, "The email is required.")
    elsif record.email !~ URI::MailTo::EMAIL_REGEXP
      record.errors.add(:email, "Invalid email format.")
    elsif User.exists?(email: record.email)
      record.errors.add(:email, "The email is already in use.")
    end
    if record.password.blank?
      record.errors.add(:password, "The password is required.")
    elsif record.password.length < 8
      record.errors.add(:password, "Password must be at least 8 characters.")
    end
    if record.password_confirmation.blank?
      record.errors.add(:password_confirmation, "Password confirmation is required.")
    elsif record.password != record.password_confirmation
      record.errors.add(:password_confirmation, "Password confirmation does not match password.")
    end
  end
end
