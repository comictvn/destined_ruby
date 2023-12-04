# PATH: /app/services/base_service_service/show.rb
# rubocop:disable Style/ClassAndModuleChildren
class BaseServiceService::Show
  attr_accessor :id, :record
  def initialize(id)
    @id = id
  end
  def execute
    find_base_service
    health_check
  end
  private
  def find_base_service
    @record = Baseservice.find_by(id: id)
    return if record.present?
    raise StandardError, 'BaseService with provided id does not exist'
  end
  def health_check
    return record.health_check if record.present?
    raise StandardError, 'BaseService with provided id does not exist'
  end
end
# rubocop:enable Style/ClassAndModuleChildren
