class VisualizationsController < ApplicationController
	before_action :authenticate_request

  def index
    json_response(@user.visualizations, :ok)
  end

  def create
    @visualization = @user.visualizations.new(visualization_params)

    if @visualization.valid?
      @visualization.save
      json_response(@visualization, :created)
    else
      json_response(@visualization, :bad_request)
    end
  end

  def update
    @visualization = Visualization.find(params[:id])
    json_response({ message: 'Could not update visualization.' }, :not_found) unless @visualization

    if @visualization.update(visualization_params)
      json_response(@visualization, :ok)
    else
      json_response({ message: 'Could not update visualization.' }, :bad_request)
    end
  end

  def destroy
    @visualization = Visualization.find(params[:id])

    if @visualization.destroy
      json_response({}, :accepted)
    else
      json_response({ message: 'Could not delete visualization' }, :not_found)
    end
  end

  private

  def visualization_params
    params.permit(:caption, :url)
  end
end
