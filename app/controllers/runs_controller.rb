class RunsController < ApplicationController
  before_action :authenticate_user!

  def new
    kennel = Kennel.where(user_id: current_user.id).first
    @run = Run.new
    @runs = Run.where(kennel_id: kennel[:id]).to_a
  end

  def create
    run = Run.new(run_params)
    user = User.where(id: current_user.id).first
    kennel = Kennel.where(user_id: user.id).last

    if run.valid? && kennel.runs.create(kennel_id: kennel.id, size_width: run.size_width, size_length: run.size_length, title: run.title, description: run.description, indoor_or_outdoor: run.indoor_or_outdoor, pets_per_run: run.pets_per_run, price: run.price.to_f, weight_limit: run.weight_limit, number_of_rooms: run.number_of_rooms, type_of_pets_allowed: run.type_of_pets_allowed, image: run.image )
      if params[:create_another_run] == "Save and Add Another Accommodation"
        flash[:notice] = "Your Accommodation was created successfully!"
        redirect_to new_run_path
      else
        flash[:notice] = "Your Accommodation was created successfully!"
        redirect_to kennel_dashboard_path
      end
    else
      error_message = "Unable to create your Accommodation, validation failed."
      run.errors.full_messages.each do |err|
        error_message << " #{err}."
      end
      flash[:notice] = error_message
      redirect_to request.referrer
    end
  end

  def update
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
    run.number_of_rooms = params[:run][:number_of_rooms]
    run.image = params[:run][:image] if !params[:run][:image].nil?

    if run.valid? && run.save!
      flash[:notice] = "Your Accommodation was updated successfully!"
      redirect_to new_run_path
    else
      error_message = "Unable to update your Accommodation, validation failed."
      run.errors.full_messages.each do |err|
        error_message << " #{err}."
      end
      flash[:notice] = error_message
      redirect_to request.referrer
    end
  end

  def destroy
    kennel = Kennel.where(user_id: current_user.id).first
    run = Run.where(id: params[:id], kennel_id: kennel[:id]).first
    run.delete
    redirect_to new_run_path
  end

  def delete_run_image
    run = Run.find(params[:id])
    run.image = nil
    if run.save!
      flash[:notice] = "Your Accommodation image was deleted successfully!"
    else
      flash[:notice] = "There was an error deleting your image, please try again."
    end
    redirect_to request.referrer
  end

  private

  def run_params
    return params.require(:run).permit(:size_width, :size_length, :title, :description, :indoor_or_outdoor, :pets_per_run, :price, :weight_limit, :number_of_rooms, :type_of_pets_allowed, :image)
  end
end
