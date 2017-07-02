class HabitTodosController < ApplicationController
  before_action :authenticate_request

  def create
    return json_response({ message: 'Habit does not exist.' }, :bad_request) unless habit
    return json_response({ message: 'You cannot mark future daily habits as complete.' }, :bad_request) unless due_date < Date.tomorrow
    return json_response({ message: 'Hmm, something went wrong.' }, :unauthorized) unless habit.user_id == @user.id

    @habit_todo = @user.habit_todos.new(habit: habit, due_date: due_date, completed: true)

    if @habit_todo.valid?
      @habit_todo.save!
      json_response(@habit_todo, :created)
    else
      json_response(@habit_todo, :bad_request)
    end
  end

  def destroy
    @habit_todo = HabitTodo.find(params[:id])

    if @habit_todo.destroy
      json_response({}, :accepted)
    else
      json_response({ message: 'Could not update Daily Habit.' }, :not_found)
    end
  end

  private

  def habit
    Habit.find(habit_id) if habit_id
  end

  def due_date
    params[:due_date].to_date if params[:due_date]
  end

  def habit_id
    params[:habit_id]
  end
end
