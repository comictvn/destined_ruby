class Api::SendOtpCodesController < Api::BaseController
  OTP_SEND_LIMIT = 5

  def create
    @phone_number = ::Auths::PhoneNumber.new({ phone_number: params.dig(:phone_number) })

    unless @phone_number.valid?
      @success = false
      @message = @phone_number.errors.full_messages
      return
    end

    if exceed_otp_send_limit?(@phone_number.formatted_phone_number)
      @success = false
      @message = 'OTP send limit reached for today'
      return
    end

    service = ::Auths::PhoneVerification.new(@phone_number.formatted_phone_number)
    result = service.send_otp

    @success = result[:success]
    @message = result[:message]
    increment_otp_send_count(@phone_number.formatted_phone_number) if @success

    if Rails.env.development? || whitelisted_number?(@phone_number.formatted_phone_number)
      log_otp_code(@phone_number.formatted_phone_number)
    else
      SendOtpCodeJob.perform_later(@phone_number.formatted_phone_number) if @success
    end
  end

  private

  def exceed_otp_send_limit?(phone_number)
    cache_key = "otp_send_limit:#{phone_number}:#{Date.today}"
    send_count = Rails.cache.read(cache_key) || 0
    send_count >= OTP_SEND_LIMIT
  end

  def increment_otp_send_count(phone_number)
    cache_key = "otp_send_limit:#{phone_number}:#{Date.today}"
    send_count = Rails.cache.read(cache_key) || 0
    Rails.cache.write(cache_key, send_count + 1, expires_in: 24.hours)
  end

  def whitelisted_number?(phone_number)
    # Assuming there's a method to check if a number is whitelisted
    WhitelistChecker.whitelisted?(phone_number)
  end

  def log_otp_code(phone_number)
    # Assuming TwilioGateway has a method to generate OTP without sending
    otp_code = TwilioGateway.generate_otp(phone_number)
    Rails.logger.info "Generated OTP for #{phone_number}: #{otp_code}"
  end
end
