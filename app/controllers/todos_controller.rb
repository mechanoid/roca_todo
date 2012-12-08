class TodosController < ApplicationController

  def index
    @todos = Todo.where(owner: owner_session).order('updated_at DESC')
    @todo  = Todo.new
  end

  def create
    @todo       = Todo.new(params[:todo])
    @todo.owner = owner_session
    @todo.save

    respond_for_request
  end

  def update
    @todo = Todo.find(params[:id])
    @todo.update_attributes(params[:todo])

    respond_for_request
  end

  private

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
