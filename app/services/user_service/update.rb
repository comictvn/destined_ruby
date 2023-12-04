module UserService
  class Update
    def initialize(id, new_password)
      @user = User.find_by(id: id)
      @new_password = new_password
    end
    def call
      return { status: :error, message: 'User does not exist' } unless @user
      begin
        @user.update_password(@new_password)
        { status: :success, message: 'Password updated successfully' }
      rescue StandardError => e
        { status: :error, message: e.message }
      end
    end
  end
end
