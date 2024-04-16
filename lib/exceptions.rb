
# typed: strict
module Exceptions
  class AuthenticationError < StandardError; end
  class BadRequest < StandardError; end
  class RecordNotFound < StandardError; end
  class UnauthorizedAccess < StandardError; end
  class ServerError < StandardError; end
  class LayerIneligibleError < StandardError; end
end
