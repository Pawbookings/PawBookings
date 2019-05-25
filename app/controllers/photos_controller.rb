class PhotosController < ApplicationController
  before_action :authenticate_user!

  def new
    @photo = Photo.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def edit
    @photo = Photo.find(params[:id])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    return redirect_to kennels_path(tab: 'photos', photo_create: ['image']) if params[:photo].nil?

    photo = Photo.new(photo_params)
    if kennel.photos.create!(kennel_id: kennel.id, image: photo.image)
      flash[:notice] = "Your Picture was created successfully!"
      redirect_to kennels_path(tab: 'photos', photo_create: nil)
    else
      error_message = []
      photo.errors.each do |attr, err|
        error_message << attr
      end

      redirect_to kennels_path(tab: 'photos', photo_create: error_message.uniq)
    end
  end

  def update
    photo = Photo.find(params[:id])
    photo.image = params[:photo][:image] if !params[:photo].nil?
    if photo.save
      flash[:notice] = "Your Picture was updated successfully!"
      redirect_to kennels_path(tab: 'photos', photo_update: nil)
    else
      error_message = []
      photo.errors.each do |attr, err|
        error_message << attr
      end
      redirect_to kennels_path(tab: 'photos', photo_update: error_message.uniq, photo_id: photo.id)
    end
  end

  def destroy
    Photo.find(params[:id]).delete
    flash[:notice] = "Your Picture was deleted successfully!"
    redirect_to kennels_path(tab: 'photos')
  end

  private

  def photo_params
    params.require(:photo).permit(:image, :kennel_id)
  end

  def kennel
    Kennel.where(user_id: current_user.id).first
  end
end
