# typed: strict
module Exceptions
  class AuthenticationError < StandardError; end
  class BadRequest < StandardError; end
  class DesignFileNotFound < StandardError; end  # This exception is already defined and does not need to be added again.
end
