
class SendOtpCodeJob < ApplicationJob
  queue_as :critical
  sidekiq_options retry: 1
  
  before_enqueue do |job|
    phone_number = job.arguments.first
    validation = Auths::PhoneVerification.new.validate_phone_number(phone_number)
    unless validation[:success]
      raise StandardError, validation[:message]
    end
  end

  def perform(phone_number)
    twilio.verifications.create(to: phone_number, channel: 'sms')
  end

  private

  def twilio
    TwilioGateway.new.verification_service
  end
end
