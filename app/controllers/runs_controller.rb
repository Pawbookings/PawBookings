class RunsController < ApplicationController
  include RunsHelper
  before_action :authenticate_user!
  def new
    @run = Run.new
  end

  def create
    @run = Run.new(run_params)
    @user = User.where(id: current_user.id).first
    @kennel = Kennel.where(user_id: @user.id).first
    if @kennel.runs.create(kennel_id: @kennel.id, size: @run.size, title: @run.title, description: @run.description, indoor_or_outdoor: @run.indoor_or_outdoor, private_or_shared: @run.private_or_shared, pets_per_run: @run.pets_per_run, price: @run.price, weight_limit: @run.weight_limit, breeds_restricted: params[:run][:breeds_restricted], number_of_rooms: @run.number_of_rooms, dates_unavailable: @run.dates_unavailable )
      if params[:create_another_run] == "Submit and create another 'Run'"
        redirect_to new_run_path
      else
        redirect_to new_amenity_path
      end
    end
  end

  private

  def run_params
    return params.require(:run).permit(:size, :title, :description, :indoor_or_outdoor, :private_or_shared, :pets_per_run, :price, :weight_limit, :breeds_restricted, :number_of_rooms, :dates_unavailable)
  end
end
