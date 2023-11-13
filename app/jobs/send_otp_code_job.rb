class SendOtpCodeJob < ApplicationJob
  queue_as :critical
  sidekiq_options retry: 1

  def perform(phone_number)
    twilio.verifications.create(to: phone_number, channel: 'sms')
  end

  private

  def twilio
    TwilioGateway.new.verification_service
  end
end
