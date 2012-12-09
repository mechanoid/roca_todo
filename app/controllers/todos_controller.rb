class TodosController < ApplicationController
  before_filter :initialize_todo, only: [:update, :destroy]

  # *******************************************************
  # *******************************************************
  # CRUD OPERATIONS
  # *******************************************************
  # *******************************************************
  def index
    todos
    @todo  = Todo.new
    render layout: false if request.xhr?
  end

  def create
    @todo       = Todo.new(params[:todo])
    @todo.owner = owner_session
    if @todo.save
      respond_with_entity
    else
      respond_with_head :bad_request
    end
  end

  def update
    if @todo.update_attributes(params[:todo])
      respond_with_entity
    else
      respond_with_head :bad_request
    end
  end

  def destroy
    @todo.destroy
    respond_with_head
  end

  # *******************************************************
  # *******************************************************
  # CRUD OPERATIONS end
  # *******************************************************
  # *******************************************************

  def delete_completed
    Todo.where("owner = ?", owner_session).where(done: true).destroy_all
    respond_with_head
  end

  def delete_active
    @active_todos = Todo.where("owner = ?", owner_session).where("done is NULL or done == 'f'")
    @active_todos.each { |todo| todo.update_attribute :done, true }
    unless request.xhr?
      redirect_to todos_path
    else
      render partial: 'todos', object: todos
    end
  end

  private


  def allowed_filters
    ['completed', 'active']
  end

  def initialize_todo
    @todo = Todo.find(params[:id])
  end

  def respond_with_head(status = :ok)
    unless request.xhr?
      redirect_to todos_path
    else
      head status
    end
  end

  def respond_with_entity
    unless request.xhr?
      redirect_to todos_path
    else
      render @todo, layout: false
    end
  end

  def owner_session
    # using session id for a simple identification / authentication
    # of a user, cause we don't want a login here.
    return @owner_session if @owner_session
    @owner_session = session[:session_id]
  end

  def todos
    return @todos if @todos
    query  = Todo.where('description IS NOT NULL')
    query  = query.where("owner = ?", owner_session)
    @todos = query.order('updated_at DESC')
  end
end
