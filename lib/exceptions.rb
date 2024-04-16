# typed: strict
module Exceptions
  class AuthenticationError < StandardError; end
  class BadRequest < StandardError; end
  class DesignFileNotFoundError < StandardError; end
  class InvalidColorCodeFormatError < StandardError; end
  class AccessDeniedError < StandardError; end
  class InvalidAccessLevelError < StandardError; end

  class GroupNamingError < StandardError; end
  class GroupCreationError < StandardError; end
end
end
