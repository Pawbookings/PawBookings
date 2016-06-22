class PetsController < ApplicationController
  def new
    @pet = Pet.new
  end

  def create
    @pet = Pet.new(pet_params)
    @customer_emergency_contact = CustomerEmergencyContact.where(user_id: current_user.id).first
    @user = User.where(id: current_user.id).first
    if @user.completed_registration.nil?
      UserMailer.new_customer_registration(current_user).deliver_now
      @user.completed_registration = true
      @user.save
    end
    if @customer_emergency_contact.pets.create(customer_emergency_contact_id: @customer_emergency_contact.id, name: @pet.name, cat_or_dog: @pet.cat_or_dog, breed: @pet.breed, dob: @pet.dob, temperament: @pet.temperament, vaccinations: @pet.vaccinations, primary_veterinarian: @pet.primary_veterinarian, primary_veterinarian_phone: @pet.primary_veterinarian_phone)
      if params[:create_another_pet] == "Submit and create another 'Pet'"
        redirect_to new_pet_path
      else
        redirect_to customer_dashboard_path
      end
    end
  end

  private

  def pet_params
    return params.require(:pet).permit(:name, :cat_or_dog, :breed, :dob, :temperament, :vaccinations, :primary_veterinarian, :primary_veterinarian_phone)
  end
end
