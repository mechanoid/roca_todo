class TodosController < ApplicationController
  before_filter :initialize_todo, only: [:update, :destroy]

  # *******************************************************
  # *******************************************************
  # CRUD OPERATIONS
  # *******************************************************
  # *******************************************************
  def index
    query  = Todo.where('description IS NOT NULL')
    query  = query.where("owner = ?", owner_session)
    @todos = query.order('updated_at DESC')
    @todo = Todo.new
  end

  def create
    @todo       = Todo.new(params[:todo])
    @todo.owner = owner_session
    @todo.save
    respond_for_request
  end

  def update
    @todo.update_attributes(params[:todo])
    respond_for_request
  end

  def destroy
    @todo.destroy
    unless request.xhr?
      redirect_to todos_path
    else
      head :ok
    end
  end

  # *******************************************************
  # *******************************************************
  # CRUD OPERATIONS end
  # *******************************************************
  # *******************************************************

  private
  def allowed_filters
    ['completed', 'active']
  end

  def initialize_todo
    @todo = Todo.find(params[:id])
  end

  def respond_for_request
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

end
