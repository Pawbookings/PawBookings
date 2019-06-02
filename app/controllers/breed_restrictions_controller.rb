class BreedRestrictionsController < ApplicationController
  before_action :authenticate_user!

  def new
    @breed_restriction = BreedRestriction.new
    if params[:mobile].nil?
      respond_to do |format|
        format.html
        format.js
      end
    else
      @breed_create = params[:breed_create]
    end
  end

  def edit
    @breed_restriction = BreedRestriction.find(params[:id])
    if params[:mobile].nil?
      respond_to do |format|
        format.html
        format.js
      end
    else
      @breed_update = params[:breed_update]
      @breed_id = params[:breed_id]
    end
  end

  def create
    breed_restriction = BreedRestriction.new(breed_restriction_params)
    if breed_restriction.valid? && kennel.breed_restrictions.create!(kennel_id: kennel[:id], breed: breed_restriction[:breed])
      flash[:notice] = "A Breed Restriction was created successfully!"
      redirect_to kennels_path(tab: 'breed', breed_create: nil)
    else
      error_message = []
      breed_restriction.errors.each do |attr,err|
        error_message << attr
      end
      if params[:breed_restriction][:mobile] != 'true'
        redirect_to kennels_path(tab: 'breed', breed_create: error_message.uniq)
      else
        redirect_to new_breed_restriction_path(mobile: true, breed_create: error_message.uniq)
      end
    end
  end

  def update
    breed_restriction = BreedRestriction.find(params[:id])
    breed_restriction.breed = params[:breed_restriction][:breed]
    if breed_restriction.valid? && breed_restriction.save
      flash[:notice] = "Your Breed Restriction was updated successfully!"
      redirect_to kennels_path(tab: 'breed', breed_update: nil)
    else
      error_message = []
      breed_restriction.errors.each do |attr, err|
        error_message << attr
      end
      if params[:breed_restriction][:mobile] != 'true'
        redirect_to kennels_path(tab: 'breed', breed_update: error_message.uniq, breed_id: breed_restriction.id)
      else
        redirect_to edit_breed_restriction_path(mobile: true, breed_update: error_message.uniq, breed_id: breed_restriction.id)
      end
    end
  end

  def destroy
    BreedRestriction.find(params[:id]).delete
    flash[:notice] = "Your Breed Restriction was deleted."
    redirect_to kennels_path(tab: 'breed')
  end

  private

  def breed_restriction_params
    params.require(:breed_restriction).permit(:breed)
  end

  def kennel
    Kennel.where(user_id: current_user).first
  end
end
