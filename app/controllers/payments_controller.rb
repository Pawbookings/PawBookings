class PaymentsController < ApplicationController
  include UsersHelper

  def new
    get_amenity_info
    get_price_total
    get_pets_total
    check_pets_type_for_runs
    if !current_user.nil?
      @pets = Pet.where(user_id: current_user)
    end
  end

  def create
    @kennel_info = JSON.parse params[:kennel_info].gsub('=>', ':')
    get_pet_stay_dates
    reservation_maxes_runs?
    if !@maxing_runs.empty?
      redirect_to request.referrer
      flash[:notice] = "Your run is not available: #{@maxing_runs.flatten}"
      return false
    end
    if current_user.nil?
      random_password
      @kennel = Kennel.find(@kennel_info["kennel_id"])

      # if user not logged in and doesnt have an account
      if User.where(email: params[:customer_email].downcase).blank?
        @user = User.create!(email: params[:customer_email].downcase, phone: params[:customer_phone], first_name: params[:customer_first_name].downcase, last_name: params[:customer_last_name].downcase, password: @encrypted_password, password_confirmation: @encrypted_password, kennel_or_customer: "customer" )
        get_inputed_pet_names
        register_pets
        get_pet_ids
        get_run_ids
        process_payment
      else
        # if user not logged in but has an account
        @user = User.where(email: params[:customer_email].downcase, kennel_or_customer: "customer").first
        if @user.nil?
          flash[:notice] = "This email cannot be used to make reservations. Please choose another email."
          redirect_to request.referrer
          return false
        end
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
      @kennel = Kennel.find(@kennel_info["kennel_id"])
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

  def get_amenity_info
    @amenities_total = 0
    @amenities_list = []
    params.each do |key, val|
      if key.include? "amenity_id"
        if val.to_i > 0
          amenity_id = key.split("_")[2]
          @amenities_total += (params["amenity_price_#{amenity_id}"].to_f * val.to_f)
          @amenities_list << [amenity_id, val.to_i, params["amenity_price_#{amenity_id}"], params["amenity_description_#{amenity_id}"], params["amenity_title_#{amenity_id}"]]
        end
      end
    end
    group_amenity_ids
  end

  def group_amenity_ids
    @amenity_ids = []
    @amenity_details = []
    @amenities_list.each do |a_id, count, price, description, title|
      @amenity_ids << a_id
      @amenity_details << [title, description, price, count]
    end
  end

  def get_pet_stay_dates
    @pet_stay_date_range = (Date.parse(@kennel_info["check_in"])..Date.parse(@kennel_info["check_out"])).map {|date| date}
  end

  def reservation_maxes_runs?
    @run_ids = []
    counter = @kennel_info["number_of_rooms"].to_i
    counter.times do
      @run_ids << @kennel_info["room_#{counter}_id"].split("_")[1]
    end
    group_run_ids
  end

  def group_run_ids
    @grouped_run_ids = []
    @run_ids.each do |r_id|
      if @grouped_run_ids.empty?
        @grouped_run_ids << [r_id, 1]
      else
        @grouped_run_ids.map! do |key, val|
          if key == r_id
            [key, val += 1]
          else
            @grouped_run_ids << [r_id.to_s, 1]
          end
        end
      end
    end
    get_relevant_reservations
  end

  def get_relevant_reservations
    @reservations = Reservation.where(kennel_id: @kennel_info["kennel_id"], completed: "false")
    filter_reservation_dates
  end

  def filter_reservation_dates
    @relevant_runs_and_dates = []
    @reservations.each do |res|
      reservation_date_range = (res[:check_in_date]..res[:check_out_date]).map {|date| date}
      reservation_date_range.each do |res_date|
        if @pet_stay_date_range.include? res_date
          JSON.parse(res[:run_ids]).each do |run_id|
            @relevant_runs_and_dates << [run_id.to_s, res_date]
          end
        end
      end
    end
    group_filtered_reservation_dates
  end

  def group_filtered_reservation_dates
    @grouped_filtered_reservation_dates = []
    @relevant_runs_and_dates.count.times do
      if !@relevant_runs_and_dates.empty?
        @grouped_filtered_reservation_dates << [@relevant_runs_and_dates[0][0], @relevant_runs_and_dates[0][1] ,@relevant_runs_and_dates.count(@relevant_runs_and_dates[0])]
        @relevant_runs_and_dates.delete(@relevant_runs_and_dates[0])
      end
    end
    res_dates_maxed?
  end

  def res_dates_maxed?
    @maxing_runs = []
    @grouped_filtered_reservation_dates.each do |run_id, date, count|
      run = Run.find(run_id)
      @grouped_run_ids.each do |r_id, r_count|
        if run_id == r_id
          if (r_count + count) > run[:number_of_rooms]
            @maxing_runs << [run[:title]]
          end
        end
      end
    end
    @maxing_runs = @maxing_runs.uniq
  end

  def check_pets_type_for_runs
    type_of_pets_allowed = []
    params.each_pair do |k, v|
      type_of_pets_allowed << v if k.include? "type_of_pets_allowed"
    end

    if (type_of_pets_allowed.include? "dog") && (type_of_pets_allowed.include? "cat")
      if !(params[:number_of_dogs].to_i > 0) && !(params[:number_of_cats].to_i > 0)
        redirect_to request.referrer
        return false
      end
    elsif type_of_pets_allowed.include? "dog"
      if !(params[:number_of_dogs].to_i > 0)
        redirect_to request.referrer
        return false
      end
    else
      if !(params[:number_of_cats].to_i > 0)
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
      @user.pets.create!(user_id: @user[:id], name: params["pet_name_#{counter}"], cat_or_dog: params["pet_type_#{counter}"], breed: params["pet_breed_#{counter}"], weight: params["pet_weight_#{counter}"], special_instructions: params["pet_special_instructions_#{counter}"], vaccinations: params["pet_vaccinations_#{counter}"], spay_or_neutered: params["pet_spay_or_neutered_#{counter}"])
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
            @user.pets.create!(user_id: @user[:id], name: params["pet_name_#{pet_number}"], cat_or_dog: params["pet_type_#{pet_number}"], breed: params["pet_breed_#{pet_number}"], weight: params["pet_weight_#{pet_number}"], special_instructions: params["pet_special_instructions_#{pet_number}"], vaccinations: params["pet_vaccinations_#{pet_number}"], spay_or_neutered: params["pet_spay_or_neutered_#{pet_number}"])
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
    if payment.payment_successful?(params, params[:total_price].to_f)
      get_room_info
      if @kennel.reservations.create(
                                   user_id: @user.id,
                                   check_in_date: @kennel_info["check_in"],
                                   check_out_date: @kennel_info["check_out"],
                                   room_details: @room_details,
                                   total_price: params[:total_price],
                                   payment_first_name: params[:payment_first_name].downcase,
                                   payment_last_name: params[:payment_last_name].downcase,
                                   customer_first_name: params[:customer_first_name].downcase,
                                   customer_last_name: params[:customer_last_name].downcase,
                                   customer_email: params[:customer_email].downcase,
                                   customer_phone: params[:customer_phone],
                                   pet_ids: @pet_ids,
                                   run_ids: @run_ids,
                                   amenity_ids: params[:amenity_ids],
                                   amenity_details: params[:amenity_details],
                                   transID: params[:transId],
                                   card_number: get_credit_card_num.join(""),
                                   expiration_date: params[:card_expiration_date],
                                   completed: "false",
                                   checked_in: "false",
                                   checked_out: "false",
                                   three_weeks_before_email_reminder: "false",
                                   one_week_before_email_reminder: "false",
                                   day_before_email_reminder: "false").valid?

        reservation = Reservation.where(customer_email: params[:customer_email].downcase).first
        reservation.kennelID = reservation[:kennel_id]
        reservation.userID = reservation[:user_id]
        reservation.reservationID = reservation[:id]
        reservation.save!

        UserMailer.reservation_confirmation(reservation[:id], @total_price).deliver_now
        if upload_vaccination_records?
          return redirect_to vaccination_upload_after_payment_path(id: @user[:id], customer_email: params[:customer_email], transID: params[:transId], res_id: reservation[:id], pet_ids: @pet_ids, total_pets: params[:total_pets])
        else
          return redirect_to reservation_path(id: @user[:id], customer_email: params[:customer_email], transID: params[:transId], res_id: reservation[:id])
        end
      else
        return redirect_to request.referrer
      end
    else
      redirect_to request.referrer
    end
  end

  def upload_vaccination_records?
    num_of_rooms = params[:total_pets].to_i
    counter = num_of_rooms

    num_of_rooms.times do
      if params["pet_vaccinations_#{counter}"] == "true"
        return true
      end
      counter -= 1
    end
  end

  def vaccination_upload_after_payment
    total_pets = params[:total_pets].to_i
    @counter = total_pets
    @pets = []
    params[:pet_ids].each do |pet_id|
      pet = Pet.find(pet_id)
      @pets << pet if pet[:vaccinations] == "true"
    end
  end

  def get_room_info
    @room_details = []
    counter = @kennel_info["number_of_rooms"].to_i
    @kennel_info["number_of_rooms"].to_i.times do
      @room_details << [@kennel_info["room_#{counter}_name"], @kennel_info["room_#{counter}_price"]]
      counter -= 1
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
    @total_price_without_tax = 0
    @tax_amount = 0
    params.each_pair do |k, v|
      @total_price += v.to_f if (k.to_s.include? "total_price") || ((k.to_s.include? "room") && (k.to_s.include? "price"))
    end
    number_of_nights = @kennel_info.nil? ? params["number_of_nights"] : @kennel_info["number_of_nights"]
    @total_price = @total_price * number_of_nights.to_i
    if params[:amenities_total].nil?
      params[:amenities_total] = @amenities_total
    end


    if params[:amenities_total] == 0
      @total_price_without_tax = @total_price
    else
      @total_price_without_tax = @total_price + params[:amenities_total].to_f
      @total_price += params[:amenities_total].to_f
    end
    @tax_amount = (@total_price * (params[:kennel_sales_tax].to_f * 0.01)).round(2)
    @total_price += @tax_amount

    @total_price = @total_price.round(2)
    @total_price_without_tax = @total_price_without_tax.round(2)
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
