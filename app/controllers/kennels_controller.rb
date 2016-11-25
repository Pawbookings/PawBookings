class KennelsController < ApplicationController
  before_action :authenticate_user!

  def new
    @kennel = Kennel.new
  end

  def create
    kennel = Kennel.new(kennel_params)
    user = User.where(id: current_user.id).first
    if kennel.valid? && !kennel_completed_registration? && kennel.save! && user.kennel = kennel
      kennel.userID = user[:id]
      kennel.kennelID = kennel[:id]
      kennel.save!
      HoursOfOperationsController.new.create(kennel[:id])
      UserMailer.new_kennel_registration(current_user).deliver_now
      user.completed_registration = "true"
      user.save!
      redirect_to kennel_dashboard_path
    else
      flash[:notice]
      redirect_to kennel_dashboard_path
    end
  end

  def update
    kennel = Kennel.find(params[:id])
    kennel.name = params[:kennel][:name]
    kennel.address = params[:kennel][:address]
    kennel.mission_statement = params[:kennel][:mission_statement]
    kennel.city = params[:kennel][:city]
    kennel.state = params[:kennel][:state]
    kennel.zip = params[:kennel][:zip]
    kennel.email = params[:kennel][:email]
    kennel.avatar = params[:kennel][:avatar] if !params[:kennel][:avatar].nil?
    kennel.save!
    redirect_to kennel_dashboard_path
  end

  def kennel_dashboard
    if !current_user.nil?
      @user = User.find(current_user.id)
      @kennel = Kennel.where(user_id: current_user.id).first
      if !@kennel.nil?
        reservations = Reservation.where(kennel_id: @kennel[:id])
        @reservations = reservations if !reservations.blank?
        @hours_of_operation = HoursOfOperation.where(kennel_id: @kennel[:id]).first
        session[:hours_of_operation_id] = @hours_of_operation[:id]
        # @photo = Photo.where(kennel_id: @kennel.id).first
      end
    end
    get_most_booked_runs if !@reservations.nil?
    filter_reservation_search if !params[:search_by].blank?
  end

  def filter_reservation_search
    search_by = params[:search_by]
    @reservation_search_results = Reservation.where(search_by.to_sym => params[:reservation_search].capitalize, kennel_id: @kennel[:id]).order(created_at: :desc).limit(10)
  end

  def get_most_booked_runs
    run_names_and_counts = {}
    @reservations.each do |res|
      JSON.parse(res[:room_details]).each do |name, price|
        if run_names_and_counts[name.to_sym].blank?
          run_names_and_counts.merge!(name.to_sym => 1)
        else
          run_names_and_counts[name.to_sym] = (run_names_and_counts[name.to_sym] += 1)
        end
      end
    end
    @run_names_and_counts = run_names_and_counts
  end

  def kennel_reservations
    if !params[:reservation_ids].nil?
      @run_ids_going_home = []
      @all_runs_purchased = []
      @current_reservations = params[:reservation_ids].map do |i|
        Reservation.find(i)
      end
      format_reservations
      get_reservations_going_home
      grouped_runs_going_home
      get_kennels_runs
      get_runs_available
      group_runs_available
      sanitize_group_runs_available
      check_if_no_reservations
    end
  end

  def format_reservations
    @grouped_formatted_reservations = []
    @current_reservations.each do |res|
      get_pets_staying(res)
      get_runs_purchased(res)
      get_pet_owner_info(res)
      counter = @pets_staying.length

      formatted_reservations = {
        pet_owner_id: @pet_owner[:id],
        reservation_id: res[:id],
        first_name: @pet_owner[:first_name],
        last_name: @pet_owner[:last_name],
        phone: @pet_owner[:phone],
        email: @pet_owner[:email],
        check_in: unsanitize_date(res[:check_in_date].to_s),
        check_out: unsanitize_date(res[:check_out_date].to_s)
      }

      counter = 1
      @pets_staying.each do |pet|
        formatted_reservations.merge!("pet_name_#{counter}".to_sym => pet[:name], "pet_weight_#{counter}".to_sym => pet[:weight], "pet_weight_#{counter}".to_sym => pet[:type], "pet_breed_#{counter}".to_sym => pet[:breed], "pet_vaccinations_#{counter}".to_sym => pet[:vaccinations], "pet_spay_or_neutered_#{counter}".to_sym => pet[:spay_or_neutered], "pet_special_instructions_#{counter}".to_sym => pet[:special_instructions] )
        counter += 1
      end

      counter = 1
      @runs_purchased.each do |run|
        formatted_reservations.merge!("run_id_#{counter}".to_sym => run[:id], "run_name_#{counter}".to_sym => run[:title])
        counter += 1
      end

      @grouped_formatted_reservations << formatted_reservations
    end
  end

  def get_pets_staying(res)
    @pets_staying = []
    JSON.parse(res[:pet_ids]).each do |pet_id|
      @pets_staying << Pet.find(pet_id)
    end
  end

  def get_runs_purchased(res)
    @runs_purchased = []
    @customer_number_of_rooms = 0
    JSON.parse(res[:run_ids]).each do |run_id|
      run = Run.find(run_id)
      @runs_purchased << run
      @all_runs_purchased << run
    end
    @customer_number_of_rooms = @runs_purchased.count
  end

  def get_pet_owner_info(res)
    @pet_owner = User.find(res[:user_id])
  end

  def get_reservations_going_home
    @reservations_going_home = []
    @grouped_formatted_reservations.each do |res|
      if res[:check_out] == params[:date]
        get_dynamic_run_id(res)
        get_dynamic_run_names(res)
        @reservations_going_home << [res[:reservation_id], @customer_run_ids, @customer_run_names]
      end
    end
  end

  def get_dynamic_run_id(res)
    @customer_run_ids = []
    res.each do |key, val|
      @customer_run_ids << val if key.to_s.include? "run_id"
    end
  end

  def get_dynamic_run_names(res)
    @customer_run_names = []
    res.each do |key, val|
      @customer_run_names << val if key.to_s.include? "run_name"
    end
  end

  def grouped_runs_going_home
    @grouped_runs_going_home_count = []
    holder = @reservations_going_home.flatten
    @reservations_going_home.each do |res|
      res[2].each do |name|
        if holder.include? name
          @grouped_runs_going_home_count << [name, holder.count(name)]
          holder.delete name
        end
      end
      res[1].each do |id|
        @run_ids_going_home << id
      end
    end
  end

  def get_kennels_runs
    @all_kennels_runs = Run.where(kennel_id: params[:kennel_id])
  end

  def get_runs_available
    split_kennels_runs = []
    subtracted_runs = []
    added_runs = []
    @all_kennels_runs.each do |k_run|
      split_kennels_runs << [k_run[:id].to_s, k_run[:title], k_run[:number_of_rooms].to_i]
    end

    @all_runs_purchased.each do |rp|
      split_kennels_runs.each do |r_id, r_title, r_number_of_rooms|
        if rp[:id] == r_id.to_i
          subtracted_runs << [r_id, r_title, r_number_of_rooms -= 1]
        end
      end
    end

    @runs_available = subtracted_runs
  end

  def group_runs_available
    @grouped_runs_occupied = []
    holder = @runs_available.flatten
    @runs_available.each do |r_id, r_title, r_number_of_rooms|
      if holder.include? r_id
        @grouped_runs_occupied << [r_id, r_title, holder.count(r_id)]
        holder.delete(r_id)
      end
    end
  end

  def sanitize_group_runs_available
    runs = []
    if !@run_ids_going_home.empty?
      @grouped_runs_occupied.map! do |r_id, r_title, r_number_of_rooms|
        if @run_ids_going_home.include? r_id.to_i
          amount = @run_ids_going_home.count(r_id.to_i)
          @run_ids_going_home.delete(r_id.to_i)
          [r_id, r_title, r_number_of_rooms -= amount]
        else
          [r_id, r_title, r_number_of_rooms]
        end
      end
    end

    @all_kennels_runs.each do |k_run|
      @grouped_runs_occupied.each do |r_id, r_title, r_number_of_rooms|
        if k_run[:number_of_rooms] == r_number_of_rooms
          runs << [r_id, r_title, r_number_of_rooms, true]
        else
          runs << [r_id, r_title, r_number_of_rooms, false]
        end
      end
    end
    @grouped_runs_occupied = runs.uniq
  end

  def check_if_no_reservations
    @grouped_runs_occupied.each do |r_id, r_title, r_number_of_rooms, maxed|
      if r_number_of_rooms == 0
        @no_reservations = true
      else
        @no_reservations = false
        return @no_reservations
      end
    end
  end

  def kennel_searched_reservation
    @reservation = Reservation.find(params[:id])
    @pets = []
    @pet_ids = []
    JSON.parse(@reservation[:pet_ids]).each do |p_id|
      pet = Pet.find(p_id)
      @pets << pet
      @pet_ids << pet[:id]
    end
  end



# TODO get rid of my_kennel_info
  def my_kennel_info
    @kennel = Kennel.where(id: params[:kennel_id])
    if !@kennel.empty?
      if current_user.id == @kennel.first.user_id
        @runs = Run.where(kennel_id: params[:kennel_id])
        @policies = Policy.where(kennel_id: params[:kennel_id])
        @amenities = Amenity.where(kennel_id: params[:kennel_id])
      else
        redirect_to kennel_dashboard_path
      end
    else
      redirect_to kennel_dashboard_path
    end
  end

  private

  def kennel_params
    return params.require(:kennel).permit(:avatar, :name, :cats_or_dogs, :address, :city, :state, :zip, :phone, :email, :mission_statement, :sales_tax )
  end

end
