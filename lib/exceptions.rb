# typed: strict
module Exceptions
  class AuthenticationError < StandardError; end
  class BadRequest < StandardError; end
  class RecordNotFound < StandardError; end
  class ForceUpdateRequired < StandardError; end
  class ForceUpdateAppVersionNotFound < StandardError; end
  class InvalidIDFormatError < StandardError; end
  class InvalidPlatformError < StandardError; end
  # Resolving the conflict by renaming ForceUpdateBooleanError to ForceUpdateNotBooleanError
  class ForceUpdateNotBooleanError < StandardError; end
  class VersionBlankError < StandardError; end
  class ReasonTooLongError < StandardError; end
  # Keeping the additional exception from the existing code
  class InvalidForceUpdateAppVersionIDError < StandardError; end
end
