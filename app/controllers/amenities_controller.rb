class AmenitiesController < ApplicationController
  before_action :authenticate_user!

  def new
    @amenity = Amenity.new
  end

  def create
    @amenity = Amenity.new(amenity_params)
    @user = User.where(id: current_user.id).first
    @kennel = Kennel.where(user_id: @user.id).first
    if @kennel.amenities.create(kennel_id: @kennel.id, description: @amenity.description, price: @amenity.price)
      if params[:create_another_amenity] == "Submit and create another 'Amenity'"
        redirect_to new_amenity_path
      else
        redirect_to new_policy_path
      end
    end
  end

  private

  def amenity_params
    return params.require(:amenity).permit(:description, :price)
  end

end
