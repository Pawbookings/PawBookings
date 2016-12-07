class PetsController < ApplicationController
  before_action :authenticate_user!, except: [:update]

  def new
    @pet = Pet.new
    @pets = Pet.where(user_id: current_user.id)
  end

  def create
    params[:pet][:breed] = "cat" if params[:pet][:cat_or_dog] == "cat"
    pet = Pet.new(pet_params)
    user = User.find(current_user.id)
    if pet.valid? && user.pets.create!(user_id: user.id, name: pet.name, cat_or_dog: pet.cat_or_dog, breed: pet.breed, weight: pet.weight, vaccinations: pet.vaccinations, spay_or_neutered: pet.spay_or_neutered, vaccination_record: pet.vaccination_record)
      redirect_to new_pet_path
    else
      redirect_to new_pet_path
    end
  end

  def update
    pet = Pet.find(params[:id])
    pet.name = params[:pet][:name] if !params[:pet][:name].nil?
    pet.weight = params[:pet][:weight] if !params[:pet][:weight].nil?
    pet.vaccinations = params[:pet][:vaccinations] if !params[:pet][:vaccinations].nil?
    pet.spay_or_neutered = params[:pet][:spay_or_neutered] if !params[:pet][:spay_or_neutered].nil?
    pet.special_instructions = params[:pet][:special_instructions] if !params[:pet][:special_instructions].nil?
    pet.vaccination_record = params[:pet][:vaccination_record] if !params[:pet][:vaccination_record].nil?
    pet.save!
    redirect_to request.referrer
  end

  def destroy
    pet = Pet.where(id: params[:id], user_id: current_user.id).first
    pet.delete
    redirect_to new_pet_path
  end

  private

  def pet_params
    return params.require(:pet).permit(:name, :cat_or_dog, :special_instructions, :breed, :weight, :vaccinations, :spay_or_neutered, :vaccination_record)
  end
end
