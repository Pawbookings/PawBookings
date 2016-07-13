class RunsController < ApplicationController
  before_action :authenticate_user!

  def new
    @run = Run.new
  end

  def create
    @run = Run.new(run_params)
    @user = User.where(id: current_user.id).first
    @kennel = Kennel.where(user_id: @user.id).last
    if @kennel.runs.create(kennel_id: @kennel.id, size_width: @run.size_width, size_length: @run.size_length, title: @run.title, description: @run.description, indoor_or_outdoor: @run.indoor_or_outdoor, pets_per_run: @run.pets_per_run, price: @run.price, weight_limit: @run.weight_limit, breeds_restricted: params[:run][:breeds_restricted], number_of_rooms: @run.number_of_rooms, dates_unavailable: @run.dates_unavailable )
      if params[:create_another_run] == "Submit and create another 'Run'"
        redirect_to new_run_path
      else
        redirect_to kennel_dashboard_path
      end
    end
  end

  private

  def run_params
    return params.require(:run).permit(:size_width, :size_length, :title, :description, :indoor_or_outdoor, :pets_per_run, :price, :weight_limit, :breeds_restricted, :number_of_rooms, :dates_unavailable)
  end
end
