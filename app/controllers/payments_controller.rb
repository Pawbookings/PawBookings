class PaymentsController < ApplicationController
  include UsersHelper
  def new
    get_price_total
    get_pets_total
    check_pets_type_for_runs
    # check_max_pets_allowed
  end

  def create
    if current_user.nil?
      random_password
      @kennel_info = JSON.parse params[:kennel_info].gsub('=>', ':')
      @kennel = Kennel.find(@kennel_info["kennel_id"])

      # if user not logged in and doesnt have an account
      if User.where(email: params[:customer_email]).blank?
        User.create!({email: params[:customer_email], phone: params[:customer_phone], first_name: params[:customer_first_name], last_name: params[:customer_last_name], password: @encrypted_password, password_confirmation: @encrypted_password, kennel_or_customer: "customer" })
        @user = User.where(email: params[:customer_email]).first
        get_inputed_pet_names
        register_pets
        get_pet_ids
        get_run_ids
        process_payment
      else
        # if user not logged in but has an account
        @user = User.where(email: params[:customer_email]).first
        if Pet.where(user_id: @user[:id]).blank?
          # if user doesnt have pets associated with them
          get_inputed_pet_names
          register_pets
          get_pet_ids
          get_run_ids
          process_payment
        else
          # if user has pets associated with them and/or handles new pets
          pets = Pet.where(user_id: @user[:id])
          get_inputed_pet_names
          register_pets_not_registered
          get_pet_ids
          get_run_ids
          process_payment
        end
      end
    else
    # user is logged in and has an account registered
      @user = User.find(current_user.id)
      if Pet.where(user_id: @user[:id]).blank?
        # if user doesnt have pets associated with them
        get_inputed_pet_names
        register_pets
        get_pet_ids
        get_run_ids
        process_payment
      else
        # if user has pets associated with them and/or has new pets
        pets = Pet.where(user_id: @user[:id])
        get_inputed_pet_names
        register_pets_not_registered
        get_pet_ids
        get_run_ids
        process_payment
      end
    end
  end

  def check_pets_type_for_runs
    type_of_pets_allowed = []
    params.each_pair do |k, v|
      type_of_pets_allowed << v if k.include? "type_of_pets_allowed"
    end

    if (type_of_pets_allowed.include? "dog") && (type_of_pets_allowed.include? "cat")
      if (params[:number_of_dogs].to_i > 0) && (params[:number_of_cats].to_i > 0)
      else
        redirect_to request.referrer
        return false
      end
    elsif type_of_pets_allowed.include? "dog"
      if params[:number_of_dogs].to_i > 0
      else
        redirect_to request.referrer
        return false
      end
    else
      if params[:number_of_cats].to_i > 0
      else
        redirect_to request.referrer
        return false
      end
    end
    check_max_pets_allowed
  end

  def check_max_pets_allowed
    dog_room_max_num = 0
    cat_room_max_num = 0
    counter = params[:number_of_rooms].to_i
    params[:number_of_rooms].to_i.times do
      if params["room_#{counter}_type_of_pets_allowed"] == "dog"
        dog_room_max_num += params["room_#{counter}_pets_per_run"].to_i
      else
        cat_room_max_num += params["room_#{counter}_pets_per_run"].to_i
      end
    end
    if dog_room_max_num < params[:number_of_dogs].to_i
      flash[:notice] = "Number of dogs exceeds the number of dogs allowed total."
      redirect_to request.referrer
      return false
    elsif cat_room_max_num < params[:number_of_cats].to_i
      flash[:notice] = "Number of cats exceeds the number of cats allowed total."
      redirect_to request.referrer
      return false
    end
    return true
  end

  def register_pets
    total_pets = @kennel_info["number_of_dogs"].to_i + @kennel_info["number_of_cats"].to_i
    counter = total_pets
    total_pets.times do
      @user.pets.create(user_id: @user[:id], name: params["pet_name_#{counter}"], cat_or_dog: params["pet_type_#{counter}"], breed: params["pet_breed_#{counter}"], weight: params["pet_weight_#{counter}"], special_instructions: params["pet_special_instructions_#{counter}"])
      counter -= 1
    end
  end

  def get_pet_ids
    @pet_ids = []
    @pet_names.each do |pn|
      pet = Pet.where(user_id: @user[:id], name: pn).first
      @pet_ids << pet[:id]
    end
  end

  def get_inputed_pet_names
    @pet_names = []
    get_pets_total
    counter = @total_pets.to_i
    @total_pets.to_i.times do
      v = params["pet_name_#{counter}"]
      @pet_names << v
      counter -= 1
    end
  end

  def register_pets_not_registered
    pet_number = []
    @pet_names.each do |pn|
      if Pet.where(user_id: @user[:id], name: pn).blank?
        params.each_pair do |k, v|
          if pn == v
            pet_number << k.split("_")[2]
            pet_number = pet_number.join("").to_i
            @user.pets.create(user_id: @user[:id], name: params["pet_name_#{pet_number}"], cat_or_dog: params["pet_type_#{pet_number}"], breed: params["pet_breed_#{pet_number}"], weight: params["pet_weight_#{pet_number}"], special_instructions: params["pet_special_instructions_#{pet_number}"])
          end
        end
      end
    end
  end

  def get_run_ids
    @run_ids = []
    counter = @kennel_info["number_of_rooms"].to_i
    @kennel_info["number_of_rooms"].to_i.times do
      v = @kennel_info["room_#{counter}_id"]
      @run_ids << v.split("_")[1].to_i
      counter -= 1
    end
  end

  def process_payment
    payment = Payment.new
    get_price_total
    if payment.payment_successful?(params, @total_price)
      # Send email to new User with ConfirmationEmail
      @kennel.reservations.create(user_id: @user.id,
                                   check_in: @kennel_info["check_in"],
                                   check_out: @kennel_info["check_out"],
                                   total_price: params[:total_price],
                                   payment_first_name: params[:payment_first_name],
                                   payment_last_name: params[:payment_last_name],
                                   pet_ids: @pet_ids,
                                   run_ids: @run_ids,
                                   trans_id: params[:transId],
                                   card_number: get_credit_card_num.join(""),
                                   expiration_date: params[:card_expiration_date] )
      return redirect_to reservation_path(id: @user[:id])
    else
      return redirect_to request.referrer
    end
  end

  def get_credit_card_num
    @last_four_card_numbers = []
    split_param = params[:payment_card_number].split("")
    @last_four_card_numbers << split_param[split_param.length - 4]
    @last_four_card_numbers << split_param[split_param.length - 3]
    @last_four_card_numbers << split_param[split_param.length - 2]
    @last_four_card_numbers << split_param[split_param.length - 1]
  end

  def get_price_total
    @total_price = 0
    params.each_pair do |k, v|
      @total_price += v.to_f if k.to_s.include? "price"
    end
    number_of_nights = @kennel_info.nil? ? params["number_of_nights"] : @kennel_info["number_of_nights"]
    @total_price = @total_price * (number_of_nights.to_i - 1)
  end

  def get_pets_total
    @total_pets = 0
    if @kennel_info.nil?
      @total_pets = params[:number_of_dogs].to_i + params[:number_of_cats].to_i
    else
      @total_pets = @kennel_info["number_of_dogs"].to_i + @kennel_info["number_of_cats"].to_i
    end
  end

end
