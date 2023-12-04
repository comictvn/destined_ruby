class TwilioGateway
  def verification_service
    client.verify.services(service_sid)
  end
  def send_message(phone_number, message)
    begin
      client.messages.create(
        from: Rails.application.credentials.dig(:twilio_phone_number),
        to: phone_number,
        body: message
      )
      return "Message sent successfully"
    rescue Exception => e
      return "Error: #{e.message}"
    end
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
