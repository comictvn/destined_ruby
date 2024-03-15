module TaskService
  class Create
    attr_reader :attributes, :task

    def initialize(attributes)
      @attributes = attributes
    end

    def execute
      @task = Task.new(attributes)

      return task if task.save

      task.errors.full_messages
    end
  end
end
