class BreedRestrictionsController < ApplicationController
  before_action :authenticate_user!

  def new
    @breed_restriction = BreedRestriction.new
    kennel = Kennel.where(user_id: current_user).first
    @breed_restrictions = BreedRestriction.where(kennel_id: kennel[:id])
  end

  def create
    breed_restriction = BreedRestriction.new(breed_restriction_params)
    kennel = Kennel.where(user_id: current_user).first
    if breed_restriction.valid? && kennel.breed_restrictions.create!(kennel_id: kennel[:id], breed: breed_restriction[:breed])
      flash[:notice] = "A Breed Restriction was created successfully!"
      if params[:create_another_breed_restriction] == "Save and Restrict Another Breed"
        redirect_to request.referrer
      else
        redirect_to kennel_dashboard_path
      end
    else
      error_message = "Unable to create Breed Restriction."
      breed_restriction.errors.full_messages.each do |err|
        error_message << " #{err}."
      end
      flash[:notice] = error_message
      redirect_to request.referrer
    end
  end

  def update
    breed_restriction = BreedRestriction.find(params[:id])
    breed_restriction.breed = params[:breed_restriction][:breed]
    if breed_restriction.valid? && breed_restriction.save!
      flash[:notice] = "Your Breed Restriction was updated successfully!"
      redirect_to request.referrer
    else
      error_message = "Your Breed Restriction failed to update."
      breed_restriction.errors.full_messages.each do |err|
        error_message << " #{err}."
      end
      flash[:notice] = error_message
      redirect_to request.referrer
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
