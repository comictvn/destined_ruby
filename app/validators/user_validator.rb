class UserValidator < ActiveModel::Validator
  def validate(record)
    if record.username.blank?
      record.errors.add(:username, "The username is required.")
    elsif record.username.length > 50
      record.errors.add(:username, "You cannot input more 50 characters.")
    end
    if record.password.blank?
      record.errors.add(:password, "The password is required.")
    elsif record.password.length < 8
      record.errors.add(:password, "Password must be at least 8 characters.")
    end
    if record.email.blank?
      record.errors.add(:email, "The email is required.")
    elsif record.email !~ URI::MailTo::EMAIL_REGEXP
      record.errors.add(:email, "Invalid email format.")
    end
  end
end
