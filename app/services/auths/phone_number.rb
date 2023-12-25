module Auths
  class PhoneNumber
    include ActiveModel::Model

    attr_accessor :phone_number
    attr_reader :errors, :formatted_phone_number

    validate :phone_number_must_be_valid

    def initialize(params = {})
      @phone_number = params[:phone_number]
      @errors = []
      @formatted_phone_number = normalize_phone_number
    end

    def normalize_phone_number
      Phonelib.parse(@phone_number).full_e164.presence
    end

    def valid?
      super && errors.empty?
    end

    def phone_number_must_be_valid
      normalized_number = normalize_phone_number
      unless normalized_number && Phonelib.valid?(normalized_number)
        errors.add(:phone_number, "is invalid")
      end
    end

    def persisted?
      false
    end

    private

    def normalize_phone_number
      Phonelib.parse(@phone_number).full_e164.presence
    end
  end
end
