class PetsController < ApplicationController
  before_action :authenticate_user!

  def new
    @pet = Pet.new
    @pets = Pet.where(user_id: current_user.id)
  end

  def create
    params[:pet][:breed] = "cat" if params[:pet][:cat_or_dog] == "cat"
    pet = Pet.new(pet_params)
    user = User.find(current_user.id)
    if pet.valid? && user.pets.create!(user_id: user.id, name: pet.name, cat_or_dog: pet.cat_or_dog, breed: pet.breed, weight: pet.weight, vaccinations: pet.vaccinations, spay_or_neutered: pet.spay_or_neutered)
      redirect_to new_pet_path
    end
  end

  def update
    params[:pet][:breed] = "cat" if params[:pet][:cat_or_dog] == "cat"
    pet = Pet.find(params[:id])
    pet.name = params[:pet][:name]
    pet.cat_or_dog = params[:pet][:cat_or_dog]
    pet.breed = params[:pet][:breed]
    pet.weight = params[:pet][:weight]
    pet.vaccinations = params[:pet][:vaccinations]
    pet.spay_or_neutered = params[:pet][:spay_or_neutered]
    pet.special_instructions = params[:pet][:special_instructions]
    pet.save!
    redirect_to new_pet_path
  end

  def destroy
    pet = Pet.where(id: params[:id], user_id: current_user.id).first
    pet.delete
    redirect_to new_pet_path
  end

  private

  def pet_params
    return params.require(:pet).permit(:name, :cat_or_dog, :special_instructions, :breed, :weight, :vaccinations, :spay_or_neutered)
  end
end
