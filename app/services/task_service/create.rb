module TaskService
  class Create
    attr_reader :attributes, :task

    def initialize(attributes)
      @attributes = attributes
    end

    def execute
      # Initialize a new Task object with the provided attributes
      @task = Task.new(attributes)

      # Attempt to save the task and handle success or validation errors accordingly
      if @task.save
        # Return the task object if saved successfully
        @task
      else
        # Return error messages if task could not be saved
        @task.errors.full_messages
      end
    end
  end
end
