# typed: strict
module Exceptions
  class AuthenticationError < StandardError; end
  class BadRequest < StandardError; end
  class RecordNotFound < StandardError; end
  class ForceUpdateRequired < StandardError; end
  # Custom exception for when a force update app version record is not found
  # Inheriting from RecordNotFound to maintain the hierarchy from the new code
  class ForceUpdateAppVersionNotFound < RecordNotFound; end
  class InvalidIDFormatError < StandardError; end
  class InvalidPlatformError < StandardError; end
  # Resolving the conflict by keeping the new exception name ForceUpdateBooleanError
  class ForceUpdateBooleanError < StandardError; end
  class VersionBlankError < StandardError; end
  class ReasonTooLongError < StandardError; end
  # Keeping the additional exception from the existing code
  class InvalidForceUpdateAppVersionIDError < StandardError; end
end
