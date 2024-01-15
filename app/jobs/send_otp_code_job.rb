class SendOtpCodeJob < ApplicationJob
  queue_as :critical
  sidekiq_options retry: 1
  
  before_enqueue do |job|
    user_id = job.arguments.first
    user = User.find(user_id)
    phone_number = user.phone_number
    validation = Auths::PhoneVerification.new.validate_phone_number(phone_number)
    unless validation[:success]
      raise StandardError, validation[:message]
    end
  end

  def perform(user_id, otp_code = nil)
    user = User.find(user_id)
    phone_number = user.phone_number

    if otp_code
      send_otp_code(phone_number, otp_code)
    else
      send_verification(phone_number)
    end
  rescue StandardError => e
    # Handle exceptions, possibly log error
  end

  private

  def twilio
    TwilioGateway.new
  end

  def send_otp_code(phone_number, otp_code)
    twilio.send_sms(phone_number, otp_code)
  rescue StandardError => e
    # Log error
  end

  def send_verification(phone_number)
    twilio.verification_service.verifications.create(to: phone_number, channel: 'sms')
  rescue StandardError => e
    # Log error
  end
end
