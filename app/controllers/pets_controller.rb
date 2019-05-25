class PetsController < ApplicationController
  before_action :authenticate_user!, except: [:update]

  def new
    @pet = Pet.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def index
    @pets = Pet.where(user_id: current_user.id)
  end

  def edit
    @pet = Pet.find(params[:id])
  end

  def create
    params[:pet][:breed] = "cat" if params[:pet][:cat_or_dog] == "cat"
    pet = Pet.new(pet_params)
    user = User.find(current_user.id)
    if pet.valid? && user.pets.create!(user_id: user.id, name: pet.name, cat_or_dog: pet.cat_or_dog, breed: pet.breed, weight: pet.weight, vaccinations: pet.vaccinations, spay_or_neutered: pet.spay_or_neutered, vaccination_record: pet.vaccination_record, avatar: pet.avatar, special_instructions: pet.special_instructions, age: pet.age)
      if params[:create_another_pet] == "Save and Add Another Pet"
        flash[:notice] = "Your Pet was successfully saved!"
        redirect_to request.referrer
      else
        flash[:notice] = "Your Pet was successfully saved!"
        redirect_to pets_path
      end
    else
      error_message = "There was an error saving your Pet."
      pet.errors.full_messages.each do |err|
        error_message << " #{err}."
      end
      flash[:notice] = error_message
      redirect_to pets_path
    end
  end

  def update
    pet = Pet.find(params[:id])
    pet.name = params[:pet][:name] if !params[:pet][:name].nil?
    pet.age = params[:pet][:age] if !params[:pet][:age].nil?
    pet.weight = params[:pet][:weight] if !params[:pet][:weight].nil?
    pet.vaccinations = params[:pet][:vaccinations] if !params[:pet][:vaccinations].nil?
    if pet.vaccinations == "false"
      pet.vaccination_record = nil
    else
      pet.vaccination_record = params[:pet][:vaccination_record] if !params[:pet][:vaccination_record].nil?
    end
    pet.avatar = params[:pet][:avatar] if !params[:pet][:avatar].nil?
    pet.spay_or_neutered = params[:pet][:spay_or_neutered]
    pet.special_instructions = params[:pet][:special_instructions] if !params[:pet][:special_instructions].nil?
    if pet.save
      flash[:notice] = "Your Pet was successfully updated!"
      redirect_to request.referrer
    else
      flash[:notice] = "There was an error updating your Pet. #{pet.errors.full_messages.first}"
      redirect_to request.referrer
    end
  end

  def destroy
    Pet.find(params[:id]).delete
    redirect_to pets_path
  end

  private

  def pet_params
    return params.require(:pet).permit(:name, :cat_or_dog, :special_instructions, :age, :breed, :weight, :vaccinations, :spay_or_neutered, :vaccination_record, :avatar)
  end
end
