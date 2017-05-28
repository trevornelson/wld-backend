class DailyTodosController < ApplicationController
	before_action :authenticate_request

	def index
		json_response(@user.daily_todos, :ok)
	end

	def create
		@daily_todo = @user.daily_todos.new(daily_todo_params)

		if @daily_todo.valid?
			@daily_todo.save
			json_response(@daily_todo, :created)
		else
			json_response(@daily_todo, :bad_request)
		end
	end

	def update
		@daily_todo = DailyTodo.find(params[:id])
		json_response({ message: 'Could not update Daily Todo.' }, :not_found) unless @daily_todo

		if @daily_todo.update(daily_todo_params)
			json_response(@daily_todo, :ok)
		else
			json_response({ message: 'Could not update Daily Todo.' }, :bad_request)
		end
	end

	def destroy
		@daily_todo = DailyTodo.find(params[:id])

		if @daily_todo.destroy
			json_response({}, :accepted)
		else
			json_response({ message: 'Could not delete Daily Todo.' }, :not_found)
		end
	end

  def prev
    todos = @user.daily_todos
              .where(due_date: first_day(:prev)..last_day(:prev))
              .order(:due_date)

    json_response(todos, :ok)
  end

  def next
    todos = @user.daily_todos
              .where(due_date: first_day(:next)..last_day(:next))
              .order(:due_date)

    json_response(todos, :ok)
  end

	private

  def mid_date(mode)
    case mode
    when :prev then number_of_weeks.weeks.ago
    when :next then number_of_weeks.weeks.from_now
    end
  end

  def first_day(mode)
    mid_date(mode).beginning_of_week(start_day = :sunday)
  end

  def last_day(mode)
    mid_date(mode).end_of_week(start_day = :sunday)
  end

  def number_of_weeks
    params[:number_of_weeks].to_i
  end

	def daily_todo_params
		params.permit(:due_date, :content, :completed)
	end
end
