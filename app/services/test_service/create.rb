# PATH: /app/services/test_service/create.rb
# rubocop:disable Style/ClassAndModuleChildren
class TestService::Create < BaseService
  attr_accessor :name, :status
  def initialize(name, status)
    @name = name
    @status = status
  end
  def call
    validate_input
    begin
      test = Test.create!(name: @name, status: @status)
      { status: 200, test: { id: test.id, name: test.name, status: test.status } }
    rescue StandardError => e
      { error: 'An unexpected error occurred', message: e.message }
    end
  end
  private
  def validate_input
    errors = []
    errors << 'Name is required' if @name.blank?
    errors << 'Name is not a string' unless @name.is_a?(String)
    errors << 'You cannot input more 200 characters.' if @name.length > 200
    errors << 'Status is required' if @status.blank?
    errors << 'Invalid status.' unless Test.statuses.include?(@status)
    raise StandardError, errors.join(', ') unless errors.empty?
  end
end
# rubocop:enable Style/ClassAndModuleChildren
