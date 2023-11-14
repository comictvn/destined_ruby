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
    if record.password_confirmation.blank?
      record.errors.add(:password_confirmation, "Password confirmation is required.")
    elsif record.password != record.password_confirmation
      record.errors.add(:password_confirmation, "Password confirmation does not match password.")
    end
    if record.email.blank?
      record.errors.add(:email, "The email is required.")
    elsif record.email !~ URI::MailTo::EMAIL_REGEXP
      record.errors.add(:email, "Invalid email format.")
    elsif User.exists?(email: record.email)
      record.errors.add(:email, "The email is already in use.")
    end
  end
  def validate_shop_update(record, shop_id, shop_name, shop_address)
    if shop_id.blank?
      record.errors.add(:shop_id, "The shop ID is required.")
    end
    if shop_name.blank?
      record.errors.add(:shop_name, "The shop name is required.")
    elsif shop_name !~ /\A[a-zA-Z0-9\s]*\z/
      record.errors.add(:shop_name, "Invalid shop name format.")
    end
    if shop_address.blank?
      record.errors.add(:shop_address, "The shop address is required.")
    elsif shop_address !~ /\A[a-zA-Z0-9\s]*\z/
      record.errors.add(:shop_address, "Invalid shop address format.")
    end
    return record.errors.empty?
  end
end
