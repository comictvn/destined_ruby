# typed: strict
module Exceptions
  class AuthenticationError < StandardError; end
  class BadRequest < StandardError; end
  class DesignFileNotFoundError < StandardError; end
  class AccessDeniedError < StandardError; end
end
