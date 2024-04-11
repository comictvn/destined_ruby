# typed: strict
module Exceptions
  class AuthenticationError < StandardError; end
  class BadRequest < StandardError; end
  class DesignFileNotFound < StandardError; end
  class ColorStyleApplicationError < StandardError; end
end
