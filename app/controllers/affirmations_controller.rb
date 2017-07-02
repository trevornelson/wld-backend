class AffirmationsController < ApplicationController
	before_action :authenticate_request

  def index
    json_response(@user.affirmations, :ok)
  end

  def create
    @affirmation = @user.affirmations.new(affirmation_params)

    if @affirmation.valid?
      @affirmation.save
      json_response(@affirmation, :created)
    else
      json_response(@affirmation, :bad_request)
    end
  end

  def update
    @affirmation = Affirmation.find(params[:id])
    json_response({ message: 'Could not update affirmation.' }, :not_found) unless @affirmation

    if @affirmation.update(affirmation_params)
      json_response(@affirmation, :ok)
    else
      json_response({ message: 'Could not update affirmation.' }, :bad_request)
    end
  end

  def destroy
    @affirmation = Affirmation.find(params[:id])

    if @affirmation.destroy
      json_response({}, :accepted)
    else
      json_response({ message: 'Could not delete affirmation' }, :not_found)
    end
  end

  private

  def affirmation_params
    params.permit(:content)
  end
end
