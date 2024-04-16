
# typed: strict
module Exceptions
  class AuthenticationError < StandardError; end
  class BadRequest < StandardError; end
  # Define additional custom exceptions below
  class RecordNotFound < StandardError; end
  class UnauthorizedAccess < StandardError; end
  class ServerError < StandardError; end
  class LayerIneligibleError < StandardError; end  # Custom exception for ineligible layers
end
