class AmenitiesController < ApplicationController
  before_action :authenticate_user!

  def new
    kennel = Kennel.where(user_id: current_user.id).first
    @amenity = Amenity.new
    @amenities = Amenity.where(kennel_id: kennel[:id]).to_a
  end

  def create
    @amenity = Amenity.new(amenity_params)
    @kennel = Kennel.where(user_id: current_user.id).first
    if @amenity.valid? && @kennel.amenities.create(kennel_id: @kennel.id, title: @amenity.title, description: @amenity.description, price: @amenity.price)
      redirect_to new_amenity_path
    end
  end

  def update
    amenity = Amenity.find(params[:id])
    amenity.title = params[:amenity][:title]
    amenity.description = params[:amenity][:description]
    amenity.price = params[:amenity][:price]
    amenity.save!
    redirect_to new_amenity_path
  end

  def destroy
    kennel = Kennel.where(user_id: current_user.id).first
    amenity = Amenity.where(id: params[:id], kennel_id: kennel[:id]).first
    amenity.delete
    redirect_to new_amenity_path
  end

  private

  def amenity_params
    return params.require(:amenity).permit(:title, :description, :price)
  end

end
