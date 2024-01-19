# typed: strict
module Exceptions
  class AuthenticationError < StandardError; end
  class BadRequest < StandardError; end
  class InvalidMediaTypeError < StandardError; end
  class MissingParametersError < StandardError; end
end
