class UserRegistrationService < BaseService
  attr_reader :username, :password, :email
  def initialize(username, password, email)
    @username = username
    @password = password
    @email = email
  end
  def call
    validator = UserValidator.new(username: username, password: password, email: email)
    return add_errors(validator.errors) unless validator.valid?
    user = User.create(username: username, password: password, email: email)
    return add_errors(user.errors) unless user.persisted?
    user
  end
  private
  def add_errors(errors)
    errors.each { |error| self.errors.add(error) }
    nil
  end
end
