module UserService
  class Update
    def initialize(user, params)
      @user = user
      @params = params
    end
    def call
      validate_params
      begin
        @user.update!(@params)
        @user
      rescue StandardError => e
        raise e.message
      end
    end
    private
    def validate_params
      raise 'This user is not found' unless @user
      raise 'Wrong format' unless @user.id.is_a?(Integer)
      raise 'The name is required.' if @params[:name].blank?
      raise 'You cannot input more 100 characters.' if @params[:name].length > 100
      raise 'Invalid email format.' unless valid_email?
      raise 'Email is already registered' if email_registered? && @user.email != @params[:email]
    end
    def valid_email?
      /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.match?(@params[:email])
    end
    def email_registered?
      User.exists?(email: @params[:email])
    end
  end
end
