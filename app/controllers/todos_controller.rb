class TodosController < Api::BaseController
  before_action :set_todo, only: %i[show update destroy]

  # GET /todos
  def index
    @todos = Todo.all
    render_response(@todos)
  end

  # GET /todos/1
  def show
    render_response(@todo)
  end

  # POST /todos
  def create
    @todo = Todo.new(todo_params)
    if @todo.save
      render_response(@todo, status: :created)
    else
      render_error(@todo.errors, status: :unprocessable_entity)
    end
  end

  # PATCH/PUT /todos/1
  def update
    if @todo.update(todo_params)
      render_response(@todo)
    else
      render_error(@todo.errors, status: :unprocessable_entity)
    end
  end

  # DELETE /todos/1
  def destroy
    @todo.destroy
    head :no_content
  end

  private

    def set_todo
      @todo = Todo.find(params[:id])
    end

    def todo_params
      params.require(:todo).permit(:title, :description)
    end
end