class AmenitiesController < ApplicationController
  before_action :authenticate_user!

  def new
    kennel = Kennel.where(user_id: current_user.id).first
    @amenity = Amenity.new
    @amenities = Amenity.where(kennel_id: kennel[:id]).to_a
  end

  def create
    amenity = Amenity.new(amenity_params)
    kennel = Kennel.where(user_id: current_user.id).first
    if amenity.valid? && kennel.amenities.create(kennel_id: kennel.id, title: amenity.title, description: amenity.description, price: amenity.price)
      if params[:create_another_amenity] == "Save and Add Another Amenity"
        flash[:notice] = "Your Amenity was created successfully!"
        redirect_to new_amenity_path
      else
        flash[:notice] = "Your Amenity was created successfully!"
        redirect_to kennel_dashboard_path
      end
    else
      error_message = "Your Amenity failed to be saved."
      amenity.errors.full_messages.each do |err|
        error_message << " #{err}."
      end
      flash[:notice] = error_message
      redirect_to request.referrer
    end
  end

  def update
    amenity = Amenity.find(params[:id])
    amenity.title = params[:amenity][:title]
    amenity.description = params[:amenity][:description]
    amenity.price = params[:amenity][:price]
    if amenity.valid? && amenity.save!
      flash[:notice] = "Your Amenity was updated successfully!"
      redirect_to new_amenity_path
    else
      error_message = "Your Amenity failed to update."
      amenity.errors.full_messages.each do |err|
        error_message << " #{err}."
      end
      flash[:notice] = error_message
      redirect_to request.referrer
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
