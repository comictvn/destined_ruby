# typed: strict
module Exceptions
  class AuthenticationError < StandardError; end
  class BadRequest < StandardError; end
  class DesignFileNotFoundError < StandardError; end
  class InvalidColorCodeFormatError < StandardError; end
  class AccessDeniedError < StandardError; end  # This class handles unauthorized access attempts to design files.
  class InvalidAccessLevelError < StandardError; end
  class ColorStyleInvalidInputError < StandardError; end  # This class handles invalid input errors for color style creation.
end
