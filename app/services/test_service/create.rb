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
      { success: 'Test created successfully', id: test.id }
    rescue StandardError => e
      { error: 'An unexpected error occurred', message: e.message }
    end
  end
  private
  def validate_input
    errors = []
    errors << 'Name is required' if @name.blank?
    errors << 'Name is not a string' unless @name.is_a?(String)
    errors << 'Status is required' if @status.blank?
    errors << 'Status is not a valid enum type' unless Test.statuses.include?(@status)
    raise StandardError, errors.join(', ') unless errors.empty?
  end
end
# rubocop:enable Style/ClassAndModuleChildren
