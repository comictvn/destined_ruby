# typed: strict
module Exceptions
  class AuthenticationError < StandardError; end
  class BadRequest < StandardError; end
  class RecordNotFound < StandardError; end
  class ForceUpdateRequired < StandardError; end
  class ForceUpdateAppVersionNotFound < StandardError; end
  class InvalidIDFormatError < StandardError; end
  class InvalidPlatformError < StandardError; end
  class ForceUpdateBooleanError < StandardError; end
  class VersionBlankError < StandardError; end
  class ReasonTooLongError < StandardError; end
end
