class AmenitiesController < ApplicationController
  before_action :authenticate_user!

  def new
    @amenity = Amenity.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def edit
    @amenity = Amenity.find(params[:id])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    amenity = Amenity.new(amenity_params)
    kennel = Kennel.where(user_id: current_user.id).first
    if amenity.valid? && kennel.amenities.create(kennel_id: kennel.id, title: amenity.title, description: amenity.description, price: amenity.price)
      flash[:notice] = "Your Amenity was created successfully!"
      return redirect_to kennels_path(tab: 'amenities')
    else
      error_message = "Your Amenity failed to be saved."
      flash[:notice] = error_message
      return redirect_to kennels_path(tab: 'amenities')
    end
  end

  def update
    amenity = Amenity.find(params[:id])
    amenity.title = params[:amenity][:title]
    amenity.description = params[:amenity][:description]
    amenity.price = params[:amenity][:price]
    if amenity.valid? && amenity.save!
      flash[:notice] = "Your Amenity was updated successfully!"
      return redirect_to kennels_path(tab: 'amenities')
    else
      error_message = "Your Amenity failed to update."
      flash[:notice] = error_message
      return redirect_to kennels_path(tab: 'amenities')
    end
  end

  def destroy
    kennel = Kennel.where(user_id: current_user.id).first
    amenity = Amenity.where(id: params[:id], kennel_id: kennel[:id]).first
    if amenity.delete
      flash[:notice] = "Your Amenity was deleted successfully."
      redirect_to request.referrer
    end
  end

  private

  def amenity_params
    return params.require(:amenity).permit(:title, :description, :price)
  end

end
