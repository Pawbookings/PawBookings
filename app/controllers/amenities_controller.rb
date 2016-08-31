class AmenitiesController < ApplicationController
  before_action :authenticate_user!

  def new
    @amenity = Amenity.new
  end

  def create
    @amenity = Amenity.new(amenity_params)
    @kennel = Kennel.where(user_id: current_user.id).last
    if @amenity.valid? && @kennel.amenities.create(kennel_id: @kennel.id, title: @amenity.title, description: @amenity.description, price: @amenity.price)
      if params[:create_another_amenity] == "Submit and create another 'Amenity'"
        redirect_to new_amenity_path
      else
        redirect_to kennel_dashboard_path
      end
    end
  end

  private

  def amenity_params
    return params.require(:amenity).permit(:title, :description, :price)
  end

end
