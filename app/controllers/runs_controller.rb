class RunsController < ApplicationController
  before_action :authenticate_user!

  def new
    @run = Run.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def edit
    @run = Run.find(params[:id])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    run = Run.new(run_params)

    if run.valid? && kennel.runs.create(kennel_id: kennel.id, size_width: run.size_width, size_length: run.size_length, title: run.title, description: run.description, indoor_or_outdoor: run.indoor_or_outdoor, pets_per_run: run.pets_per_run, price: run.price.to_f, weight_limit: run.weight_limit, number_of_rooms: run.number_of_rooms, type_of_pets_allowed: run.type_of_pets_allowed, image: run.image )
      flash[:notice] = "Your Accommodation was created successfully!"
      return redirect_to kennels_path(tab: 'runs', runs_create: nil)
    else
      error_message = []
      run.errors.each do |attr,err|
        error_message << attr
      end
      redirect_to kennels_path(tab: 'runs', runs_create: error_message.uniq)
    end
  end

  def update
    run = Run.find(params[:id])
    run.title = params[:title]
    run.size_width = params[:size_width]
    run.size_length = params[:size_length]
    run.description = params[:description]
    run.indoor_or_outdoor = params[:indoor_or_outdoor]
    run.pets_per_run = params[:pets_per_run]
    run.type_of_pets_allowed = params[:type_of_pets_allowed]
    run.price = params[:price]
    run.weight_limit = params[:weight_limit]
    run.number_of_rooms = params[:number_of_rooms]
    run.image = params[:image] if !params[:image].nil?

    if run.save
      flash[:notice] = "Your Accommodation was updated successfully!"
      return redirect_to kennels_path(tab: 'runs', runs_update: nil)
    else
      error_message = []
      run.errors.each do |attr, err|
        error_message << attr
      end
      return redirect_to kennels_path(tab: 'runs', runs_update: error_message.uniq, run_id: run.id)
    end
  end

  def destroy
    Run.find(params[:id]).delete
    if kennel.runs.nil?
      redirect_to kennel_dashboard_path
    else
      redirect_to kennels_path(tab: 'runs'), notice: 'You successfully deleted your accomodation!'
    end
  end

  def delete_run_image
    run = Run.find(params[:id])
    run.image = nil
    if run.save
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

  def kennel
    Kennel.where(user_id: current_user.id).first
  end
end
