class RunsController < ApplicationController
  before_action :authenticate_user!

  def new
    kennel = Kennel.where(user_id: current_user.id).first
    @run = Run.new
    @runs = Run.where(kennel_id: kennel[:id]).to_a
  end

  def create
    get_breeds_restricted
    run = Run.new(run_params)
    user = User.where(id: current_user.id).first
    kennel = Kennel.where(user_id: user.id).last
    params["run"]["breeds_restricted"][0] = "No Breed Restrictions"  if params["run"]["breeds_restricted"][0].blank?

    if kennel.runs.create(kennel_id: kennel.id, size_width: run.size_width, size_length: run.size_length, title: run.title, description: run.description, indoor_or_outdoor: run.indoor_or_outdoor, pets_per_run: run.pets_per_run, price: run.price.to_f, weight_limit: run.weight_limit, breeds_restricted: params[:run][:breeds_restricted], number_of_rooms: run.number_of_rooms, type_of_pets_allowed: run.type_of_pets_allowed ).valid?
      if params[:create_another_run] == "Save and Add Another Run"
        flash[:notice] = "Your Run was created successfully!"
        redirect_to new_run_path
      else
        flash[:notice] = "Your Run was created successfully!"
        redirect_to kennel_dashboard_path
      end
    else
      flash[:notice] = "Unable to create your Run, validation failed. #{run.errors.full_messages.first}"
      redirect_to request.referrer
    end
  end

  def update
    get_breeds_restricted
    run = Run.find(params[:id])
    run.title = params[:run][:title]
    run.size_width = params[:run][:size_width]
    run.size_length = params[:run][:size_length]
    run.description = params[:run][:description]
    run.indoor_or_outdoor = params[:run][:indoor_or_outdoor]
    run.pets_per_run = params[:run][:pets_per_run]
    run.type_of_pets_allowed = params[:run][:type_of_pets_allowed]
    run.price = params[:run][:price]
    run.weight_limit = params[:run][:weight_limit]
    run.breeds_restricted = params[:run][:breeds_restricted]
    run.number_of_rooms = params[:run][:number_of_rooms]

    if run.valid? && run.save!
      flash[:notice] = "Your Run was updated successfully!"
      redirect_to new_run_path
    else
      flash[:notice] = "Unable to update your Run, validation failed. #{run.errors.full_messages.first}"
      redirect_to request.referrer
    end
  end

  def destroy
    kennel = Kennel.where(user_id: current_user.id).first
    run = Run.where(id: params[:id], kennel_id: kennel[:id]).first
    run.delete
    redirect_to new_run_path
  end

  def get_breeds_restricted
    @breeds_restricted = []
    params.each do |key, val|
      @breeds_restricted << val if key.to_s.include? "breed"
    end
    params[:run][:breeds_restricted] = @breeds_restricted.to_s
  end



  private

  def run_params
    return params.require(:run).permit(:size_width, :size_length, :title, :description, :indoor_or_outdoor, :pets_per_run, :price, :weight_limit, :breeds_restricted, :number_of_rooms, :type_of_pets_allowed)
  end
end
