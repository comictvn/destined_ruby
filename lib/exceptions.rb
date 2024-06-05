# typed: strict
module Exceptions
  class AuthenticationError < StandardError; end
  class BadRequest < StandardError; end
  class ForceUpdateVersionNotFound < StandardError; end
  class ForceUpdateUnauthorizedAccess < StandardError; end
  class ForceUpdateInvalidParameters < StandardError; end
  class ForceUpdateServiceError < StandardError; end
end
