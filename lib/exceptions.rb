# typed: strict
module Exceptions
  class AuthenticationError < StandardError; end
  class BadRequest < StandardError; end
  class RecordNotFound < StandardError; end
  class ForceUpdateRequired < StandardError; end
end
