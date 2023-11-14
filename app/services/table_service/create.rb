# PATH: /app/services/table_service/create.rb
# rubocop:disable Style/ClassAndModuleChildren
class TableService::Create
  attr_accessor :name, :table
  def initialize(name)
    @name = name
  end
  def call
    create_table
  end
  private
  def create_table
    raise StandardError.new("The table name is required.") if @name.blank?
    raise StandardError.new("You cannot input more 50 characters.") if @name.length > 50
    @table = Test3.new(name: @name)
    if @table.save
      @table
    else
      raise StandardError.new(@table.errors.full_messages.join(', '))
    end
  end
end
# rubocop:enable Style/ClassAndModuleChildren
