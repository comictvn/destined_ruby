# typed: strict
module Exceptions
  class AuthenticationError < StandardError; end
  class BadRequest < StandardError; end
  class DesignFileNotFoundError < StandardError; end
  class InvalidColorCodeFormatError < StandardError; end
  # class AccessDeniedError < StandardError; end  # This class handles unauthorized access attempts to design files.
  class InvalidAccessLevelError < StandardError; end
  # class GroupCreationError < StandardError; end  # This class handles errors during group creation.
  # class GroupAssociationError < StandardError; end  # This class handles errors during the association of color styles with a group.
  # class InvalidGroupNameError < StandardError; end  # This class handles errors related to invalid group naming conventions.
  class DesignFileAccessError < StandardError; end  # This class handles errors related to design file access.
end
