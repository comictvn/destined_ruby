class TwilioGateway
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
