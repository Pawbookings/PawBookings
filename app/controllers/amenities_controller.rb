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
    if amenity.valid? && kennel.amenities.create(kennel_id: kennel.id, title: amenity.title, description: amenity.description, price: amenity.price)
      flash[:notice] = "Your Amenity was created successfully!"
      return redirect_to kennels_path(tab: 'amenities', amenity_create: nil)
    else
      error_message = []
      amenity.errors.each do |attr, err|
        error_message << attr
      end
      return redirect_to kennels_path(tab: 'amenities', amenity_create: error_message.uniq)
    end
  end

  def update
    amenity = Amenity.find(params[:id])
    amenity.title = params[:amenity][:title]
    amenity.description = params[:amenity][:description]
    amenity.price = params[:amenity][:price]
    if amenity.save
      flash[:notice] = "Your Amenity was updated successfully!"
      return redirect_to kennels_path(tab: 'amenities', amenity_update: nil)
    else
      error_message = []
      amenity.errors.each do |attr, err|
        error_message << attr
      end
      return redirect_to kennels_path(tab: 'amenities', amenity_update: error_message.uniq, amenity_id: amenity.id)
    end
  end

  def destroy
    Amenity.find(params[:id]).delete
    flash[:notice] = "Your Amenity was deleted successfully."
    redirect_to kennels_path(tab: 'amenities')
  end

  private

  def amenity_params
    return params.require(:amenity).permit(:title, :description, :price)
  end

  def kennel
    Kennel.where(user_id: current_user.id).first
  end

end
