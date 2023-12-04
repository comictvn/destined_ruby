class SendOtpCodeService < BaseService
  attr_accessor :phone_number
  def initialize(phone_number)
    @phone_number = phone_number
  end
  def call
    user = User.find_by(phone_number: @phone_number)
    return { error: 'Phone number is not registered' } unless user
    otp_code = generate_otp_code
    store_otp_code(user, otp_code)
    send_otp_code(user, otp_code)
    { success: 'OTP code sent successfully' }
  end
  private
  def generate_otp_code
    rand(100000..999999)
  end
  def store_otp_code(user, otp_code)
    OtpCode.create!(otp_code: otp_code, user_id: user.id, is_verified: false)
  end
  def send_otp_code(user, otp_code)
    TwilioGateway.new.send_message(user.phone_number, "Your OTP code is #{otp_code}")
  end
end
