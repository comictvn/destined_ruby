# typed: strict
module Exceptions
  class AuthenticationError < StandardError; end
  class BadRequest < StandardError; end
  class DesignFileNotFoundError < StandardError; end
  class InvalidColorCodeFormatError < StandardError; end
  class AccessDeniedError < StandardError; end  # This class handles unauthorized access attempts to design files.
  class ColorStyleAccessDeniedError < StandardError; end  # Handles access denied errors for color styles.
  class InvalidColorStyleInputError < StandardError; end  # Handles invalid input parameters for color styles.
  class InvalidAccessLevelError < StandardError; end
end
