class UserRegistrationService
  def register(name, status)
    # Validate input data
    raise "Name can't be blank" if name.blank?
    raise "Status can't be blank" if status.blank?
    raise "You cannot input more 200 characters." if name.length > 200
    raise "Invalid status." unless ['active', 'inactive'].include?(status)
    # Create new user
    user = User.new(name: name, status: status)
    user.save!
    # Send confirmation email
    UserMailer.with(user: user).confirmation_email.deliver_later
    user
  end
end
