class PhotosController < ApplicationController
  def new
    @photo = Photo.new
  end

  def create
    binding.pry
    @photo = Photo.new(photo_params)
    @kennel = Kennel.where(user_id: current_user.id).first
    if @kennel.photos.create(kennel_id: @kennel.id, image: @photo.image)
      redirect_to kennel_dashboard_path
    end
  end

  private

  # Use strong_parameters for attribute whitelisting
  # Be sure to update your create() and update() controller methods.

  def photo_params
    params.require(:photo).permit(:image)
  end
end
