class PetsController < ApplicationController
  before_action :authenticate_user!

  def new
    @pet = Pet.new
  end

  def create
    @pet = Pet.new(pet_params)
    @user = User.where(id: current_user.id).first
    if @user.completed_registration.nil?
      UserMailer.new_customer_registration(current_user).deliver_now
      @user.completed_registration = true
      @user.save
    end
    if @user.pets.create(user_id: @user.id, name: @pet.name, cat_or_dog: @pet.cat_or_dog, breed: @pet.breed, weight: @pet.weight, vaccinations: @pet.vaccinations, spay_or_neutered: @pet.spay_or_neutered)
      if params[:create_another_pet] == "Submit and create another 'Pet'"
        redirect_to new_pet_path
      else
        redirect_to customer_dashboard_path
      end
    end
  end

  private

  def pet_params
    return params.require(:pet).permit(:name, :cat_or_dog, :breed, :weight, :vaccinations, :spay_or_neutered)
  end
end
