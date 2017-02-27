class PaymentsController < ApplicationController
  include UsersHelper

  def new
    if current_user[:kennel_or_customer] == "kennel"
      flash[:notice] = "A Kennel account cannot book a reservation."
      return redirect_to request.referrer
    end
    if !(check_pets_type_for_runs)
      return redirect_to request.referrer
    end
    @kennel_info = params
    if !(check_max_pets_allowed)
      return redirect_to request.referrer
    end
    get_pet_stay_dates
    reservation_maxes_runs?
    if !@maxing_runs.empty?
      error_message = "Your reservation is unavailable:"
      @maxing_runs.each do |run, diff|
        error_message << " #{run[:title]} only has #{diff} room(s) left."
      end
      flash[:notice] = error_message
      return redirect_to request.referrer
    end
    get_amenity_info
    get_price_total
    get_pets_total
    if !current_user.nil?
      @pets = Pet.where(user_id: current_user)
    end
  end

  def create
    @kennel_info = JSON.parse params[:kennel_info].gsub('=>', ':')
    @kennel = Kennel.find(@kennel_info["kennel_id"])
    get_pet_stay_dates
    reservation_maxes_runs?
    if !@maxing_runs.empty?
      error_message = "Your reservation is unavailable:"
      @maxing_runs.each do |run, diff|
        error_message << " #{run[:title]} only has #{diff} room(s) left."
      end
      flash[:notice] = error_message
      return redirect_to request.referrer
    end
    if current_user.nil?
      random_password
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
      @user = User.find(current_user.id)
      if @user[:kennel_or_customer] == "kennel"
        flash[:notice] = "You cannot book a reservation using a Kennel Operator account."
        return redirect_to request.referrer
      end
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
    get_staying_pets_run_ids
  end

  def get_staying_pets_run_ids
    @pet_run_ids = []
    counter = @kennel_info["number_of_rooms"].to_i
    counter.times do
      @pet_run_ids << @kennel_info["room_#{counter}_id"].split("_")[1]
    end
    group_pet_run_ids
  end

  def group_pet_run_ids
    @grouped_pet_run_ids = []
    @pet_run_ids.length.times do
      break if @pet_run_ids[0].nil?
      @grouped_pet_run_ids << [@pet_run_ids[0].to_i, @pet_run_ids.count(@pet_run_ids[0])]
      @pet_run_ids.delete(@pet_run_ids[0])
    end
    get_relevant_reservations
  end

  def get_relevant_reservations
    @reservations = Reservation.where(kennel_id: @kennel_info["kennel_id"], completed: "false")
    if @reservations.blank?
      return @maxing_runs = []
    end
    filter_relevant_reservations
  end

  def filter_relevant_reservations
    @filtered_reservations = []
    @reservations.each do |res|
      start_date = res[:check_in_date]
      end_date = res[:check_out_date]
      start_date.upto(end_date) do |res_date|
        @pet_stay_date_range.each do |pet_date|
          @filtered_reservations << res if res_date == pet_date && res_date != res[:check_out_date]
        end
      end
    end
    group_reservation_runs_taken
  end

  def group_reservation_runs_taken
    @res_runs = []
    @grouped_res_run_ids = []
    @filtered_reservations.each do |res|
      JSON.parse(res[:run_ids]).each do |run_id|
        @res_runs << run_id
      end
    end
    @res_runs.length.times do
      break if @res_runs[0].nil?
      @grouped_res_run_ids << [@res_runs[0], @res_runs.count(@res_runs[0])]
      @res_runs.delete(@res_runs[0])
    end
    get_kennel_run_counts
  end

  def get_kennel_run_counts
    @all_run_counts = []
    @all_runs = Run.where(kennel_id: @kennel_info["kennel_id"])
    @all_runs.each do |run|
      @all_run_counts << [run[:id], run[:number_of_rooms]]
    end
    add_pet_and_res_runs_together
  end

  def add_pet_and_res_runs_together
    @new_res_run_counts = []
    @grouped_res_run_ids.each do |res_run_id, res_run_count|
      @grouped_pet_run_ids.each do |pet_run_id, pet_run_count|
        if res_run_id == pet_run_id
          @new_res_run_counts << [res_run_id, (res_run_count + pet_run_count)]
        end
      end
    end
    check_if_new_runs_max_capacity
  end

  def check_if_new_runs_max_capacity
    @maxing_runs = []
    @new_res_run_counts.each do |res_run_id, res_run_count|
      @all_run_counts.each do |run_id, run_count|
        if res_run_id == run_id && res_run_count > run_count
          @maxing_runs << [Run.find(res_run_id), (res_run_count - run_count)]
        end
      end
    end
  end

  def check_pets_type_for_runs
    type_of_pets_allowed = []
    params.each_pair do |k, v|
      type_of_pets_allowed << v if k.include? "type_of_pets_allowed"
    end
    if (params[:number_of_dogs].to_i > 0) && (params[:number_of_cats].to_i > 0)
      if !((type_of_pets_allowed.include? "dog") && (type_of_pets_allowed.include? "cat"))
        flash[:notice] = "You have not selected a room that will accommodate a Cat and/or Dog."
        return false
      end
    end
    if type_of_pets_allowed.include? "dog"
      if !(params[:number_of_dogs].to_i > 0)
        flash[:notice] = "You have not selected a room that will accommodate a Cat."
        return false
      end
    else
      if !(params[:number_of_cats].to_i > 0)
        flash[:notice] = "You have not selected a room that will accommodate a Dog."
        return false
      end
    end
    return true
  end

  def check_max_pets_allowed
    max_dog_occupancy = 0
    max_cat_occupancy = 0
    number_of_rooms = @kennel_info["number_of_rooms"].to_i
    counter = number_of_rooms
    number_of_rooms.times do
      if @kennel_info["room_#{counter}_type_of_pets_allowed"] == "dog"
        max_dog_occupancy += @kennel_info["room_#{counter}_pets_per_run"].to_i
      elsif @kennel_info["room_#{counter}_type_of_pets_allowed"] == "cat"
        max_cat_occupancy += @kennel_info["room_#{counter}_pets_per_run"].to_i
      end
      counter -= 1
    end

    if @kennel_info["number_of_dogs"].to_i > max_dog_occupancy
      flash[:notice] = "The number of dogs you chose exceeds the number of dogs allowed total."
      return false
    elsif @kennel_info["number_of_cats"].to_i > max_cat_occupancy
      flash[:notice] = "The number of cats you chose exceeds the number of cats allowed total."
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
    if payment.payment_successful?(params, params[:total_price].to_f)
      get_room_info
      if @kennel.reservations.create!(
                                   user_id: @user.id,
                                   check_in_date: @kennel_info["check_in"],
                                   check_out_date: @kennel_info["check_out"],
                                   room_details: @room_details,
                                   total_price_without_tax: params[:total_price_without_tax],
                                   tax_percentage: params[:kennel_sales_tax],
                                   tax_total_price: params[:tax_total_price],
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
        UserMailer.reservation_confirmation(reservation[:id], params[:total_price]).deliver_now
        flash[:notice] = "Your payment was processed!"
        return redirect_to reservation_path(id: @user[:id], customer_email: params[:customer_email], transID: params[:transId], res_id: reservation[:id])
      else
        flash[:notice] = "Form validation failed."
        return redirect_to request.referrer
      end
    else
      flash[:notice] = "Payment Failed. Credit card not valid."
      redirect_to request.referrer
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
