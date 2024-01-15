
class TwilioGateway
  def send_sms(phone_number, message)
    begin
      client.messages.create(
        from: Rails.application.credentials.dig(:twilio_phone_number),
        to: phone_number,
        body: message
      )
    rescue Twilio::REST::TwilioError => e
      Rails.logger.error "Twilio SMS send failed: #{e.message}"
      raise
    end
  end

  def verification_service
    client.verify.services(service_sid)
  end

  private

  def service_sid
    Rails.application.credentials.dig(:twilio_service_id)
  end

  def client
    Twilio::REST::Client.new(
      Rails.application.credentials.dig(:twilio_sid),
      Rails.application.credentials.dig(:twilio_token)
    )
  end
end
