class HabitsController < ApplicationController
  before_action :authenticate_request

  def create
    @habit = @user.habits.new(habit_params)

    if @habit.valid?
      @habit.save!
      json_response(@habit, :created)
    else
      json_response(@habit, :bad_request)
    end
  end

  def update
    @habit = Habit.find(params[:id])
    json_response({ message: 'Could not update Habit.' }, :not_found) unless @habit

    if @habit.update(habit_params)
      json_response(@habit, :ok)
    else
      json_response({ message: 'Could not update Habit.' }, :bad_request)
    end
  end

  def destroy
    @habit = Habit.find(params[:id])

    if @habit.update(active: false)
      json_response({}, :accepted)
    else
      json_response({ message: 'Could not delete Habit.' }, :not_found)
    end
  end

  private

  def habit_params
    params.permit(:content, :active)
  end
end
