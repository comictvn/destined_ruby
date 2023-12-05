# PATH: /app/services/test_service/update.rb
# rubocop:disable Style/ClassAndModuleChildren
class TestService::Update
  attr_accessor :id, :name, :status
  def initialize(id, name, status)
    @id = id
    @name = name
    @status = status
  end
  def update_test
    validate_input
    test = Test.find_by(id: @id)
    return { error: 'This test is not found' } unless test
    begin
      test.update!(name: @name, status: @status)
      { status: 200, test: test }
    rescue StandardError => e
      { error: 'An unexpected error occurred', message: e.message }
    end
  end
  private
  def validate_input
    errors = []
    errors << 'ID is required' if @id.blank?
    errors << 'ID is not a number' unless @id.is_a?(Numeric)
    errors << 'The name is required.' if @name.blank?
    errors << 'You cannot input more 200 characters.' if @name.length > 200
    errors << 'Status is required' if @status.blank?
    errors << 'Invalid status.' unless Test.statuses.include?(@status)
    raise StandardError, errors.join(', ') unless errors.empty?
  end
end
# rubocop:enable Style/ClassAndModuleChildren
