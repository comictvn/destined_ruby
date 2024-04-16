# typed: strict
module Exceptions
  class AuthenticationError < StandardError; end
  class BadRequest < StandardError; end
  class DesignFileNotFoundError < StandardError; end
  class InvalidColorCodeFormatError < StandardError; end
  class AccessDeniedError < StandardError; end
  class LayerNotFoundError < StandardError; end
  class ColorStyleMismatchError < StandardError; end
end
