class BreedRestrictionsController < ApplicationController
  before_action :authenticate_user!

  def new
    @breed_restriction = BreedRestriction.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def edit
    @breed_restriction = BreedRestriction.find(params[:id])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    breed_restriction = BreedRestriction.new(breed_restriction_params)
    kennel = Kennel.where(user_id: current_user).first
    if breed_restriction.valid? && kennel.breed_restrictions.create!(kennel_id: kennel[:id], breed: breed_restriction[:breed])
      flash[:notice] = "A Breed Restriction was created successfully!"
      redirect_to kennels_path(tab: 'breed')
    else
      error_message = "Unable to create Breed Restriction."
      flash[:notice] = error_message
      redirect_to kennels_path(tab: 'breed')
    end
  end

  def update
    breed_restriction = BreedRestriction.find(params[:id])
    breed_restriction.breed = params[:breed_restriction][:breed]
    if breed_restriction.valid? && breed_restriction.save!
      flash[:notice] = "Your Breed Restriction was updated successfully!"
      redirect_to kennels_path(tab: 'breed')
    else
      error_message = "Your Breed Restriction failed to update."
      flash[:notice] = error_message
      redirect_to kennels_path(tab: 'breed')
    end
  end

  def destroy
    kennel = Kennel.where(user_id: current_user.id).first
    breed_restriction = BreedRestriction.where(id: params[:id], kennel_id: kennel[:id]).first
    if breed_restriction.delete
      flash[:notice] = "Your Breed Restriction was deleted."
      redirect_to request.referrer
    end
  end



  private

  def breed_restriction_params
    params.require(:breed_restriction).permit(:breed)
  end

end
