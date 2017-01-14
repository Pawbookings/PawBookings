class PhotosController < ApplicationController
  before_action :authenticate_user!

  def new
    @photo = Photo.new
    kennel = Kennel.where(user_id: current_user).first
    @photos = Photo.where(kennel_id: kennel[:id])
  end

  def create
    photo = Photo.new(photo_params)
    kennel = Kennel.where(user_id: current_user.id).first
    if kennel.photos.create!(kennel_id: kennel.id, image: photo.image)
      if params[:create_another_picture] == "Save and Add Another Picture"
        flash[:notice] = "Your Picture was created successfully!"
        redirect_to request.referrer
      else
        flash[:notice] = "Your Picture was created successfully!"
        redirect_to kennel_dashboard_path
      end
    else
      flash[:notice] = "Unable to save this Picture. Please try again or choose another Picture."
      redirect_to request.referrer
    end
  end

  def update
    photo = Photo.find(params[:id])
    photo.image = params[:photo][:image] if !params[:photo].nil?
    if photo.save!
      flash[:notice] = "Your Picture was updated successfully!"
    else
      flash[:notice] = "Your Picture was not updated. Please try again."
    end
    redirect_to request.referrer
  end

  def destroy
    photo = Photo.find(params[:id])
    if photo.delete
      flash[:notice] = "Your Picture was deleted successfully!"
    else
      flash[:notice] = "Your Picture was not deleted. Please try again."
    end
    redirect_to request.referrer
  end

  private

  # Use strong_parameters for attribute whitelisting
  # Be sure to update your create() and update() controller methods.

  def photo_params
    params.require(:photo).permit(:image, :kennel_id)
  end
end
