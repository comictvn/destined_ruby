
module TaskService
  class Create
    attr_reader :attributes, :task

    def initialize(attributes)
      @attributes = attributes
    end

    def execute
      task = Task.new(attributes)

      if task.save
        task
      else
        task.errors.full_messages
      end
    end
  end
end
