module Auths
  class PhoneNumber
    include ActiveModel::Model

    attr_reader :formatted_phone_number

    def initialize(params = {})
      @formatted_phone_number = normalize_phone_number(params[:phone_number])
    end

    validates :formatted_phone_number,
              presence: true,
              format: { with: /\A(\(\+\d{1,3}\)|\+?\d+)?\d+\z/ }

    def persisted?
      false
    end

    private

    def normalize_phone_number(number)
      Phonelib.parse(number).full_e164
    end
  end
end
