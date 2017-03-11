class QuarterlyTodosController < ApplicationController
	before_action :authenticate_request

	def index
		json_response(@user.quarterly_todos, :ok)
	end

	def create
		@quarterly_todo = @user.quarterly_todos.new(quarterly_todo_params)

		if @quarterly_todo.valid?
			@quarterly_todo.save
			json_response(@quarterly_todo, :created)
		else
			json_response(@quarterly_todo, :bad_request)
		end
	end

	def update
		@quarterly_todo = QuarterlyTodo.find(params[:id])
		json_response({ message: 'Could not update Quarterly Todo.' }, :not_found) unless @quarterly_todo

		if @quarterly_todo.update(quarterly_todo_params)
			json_response(@quarterly_todo, :ok)
		else
			json_response({ message: 'Could not update Quarterly Todo.' }, :bad_request)
		end
	end

	def destroy
		@quarterly_todo = QuarterlyTodo.find(params[:id])

		if @quarterly_todo.destroy
			json_response({}, :accepted)
		else
			json_response({ message: 'Could not delete Quarterly Todo.' }, :not_found)
		end
	end

	private

	def quarterly_todo_params
		params.permit(:category, :content)
	end
end
