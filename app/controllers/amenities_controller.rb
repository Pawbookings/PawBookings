class AmenitiesController < ApplicationController
  before_action :authenticate_user!

  def new
    @amenity = Amenity.new
    if params[:mobile].nil?
      respond_to do |format|
        format.html
        format.js
      end
    else
      @amenity_create = params[:amenity_create]
    end
  end

  def edit
    @amenity = Amenity.find(params[:id])
    if params[:mobile].nil?
      respond_to do |format|
        format.html
        format.js
      end
    else
      @amenity_update = params[:amenity_update]
      @amenity_id = params[:amenity_id]
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
      if params[:amenity][:mobile] != 'true'
        redirect_to kennels_path(tab: 'amenities', amenity_create: error_message.uniq)
      else
        redirect_to new_amenity_path(mobile: true, amenity_create: error_message.uniq)
      end
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
      if params[:amenity][:mobile] != 'true'
        redirect_to kennels_path(tab: 'amenities', amenity_update: error_message.uniq, amenity_id: amenity.id)
      else
        redirect_to edit_amenity_path(mobile: true, amenity_update: error_message.uniq, amenity_id: amenity.id)
      end
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
