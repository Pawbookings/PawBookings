class KennelsController < ApplicationController
  before_action :authenticate_user!, except: [:show]

  def new
    @kennel = Kennel.new
  end

  def create
    kennel = Kennel.new(kennel_params)
    user = User.where(id: current_user.id).first
    if kennel.valid? && !kennel_completed_registration? && kennel.save! && user.kennel = kennel
      flash[:notice] = "Your Kennel was created successfully!"
      kennel.userID = user[:id]
      kennel.kennelID = kennel[:id]
      kennel.save!
      HoursOfOperationsController.new.create(kennel[:id])
      user.completed_registration = "true"
      user.save!
      redirect_to kennel_dashboard_path
    else
      error_message = "Unable to register your Kennel, validation falied."
      kennel.errors.full_messages.each do |err|
        error_message << " #{err}."
      end
      flash[:notice] = error_message
      redirect_to request.referrer
    end
  end

  def edit
    @kennel = Kennel.find(params[:id])
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
    kennel.sales_tax = params[:kennel][:sales_tax]
    kennel.avatar = params[:kennel][:avatar] if !params[:kennel][:avatar].nil?
    if kennel.valid? && kennel.save!
      flash[:notice] = "Your Kennel updated successfully!"
      redirect_to kennel_dashboard_path
    else
      flash[:notice] = "Unable to update your Kennel, validation failed. #{kennel.errors.full_messages.first}"
      redirect_to request.referrer
    end
  end

  def show
    @searched_kennel = Kennel.friendly.find(params[:id])
    @photos = Photo.where(kennel_id: @searched_kennel[:id])
    @kennel_user = User.find(@searched_kennel[:user_id])
    @runs = Run.where(kennel_id: @searched_kennel.id)
    @customer_check_in_date = unsanitize_date(params[:search_info][:check_in])
    @customer_check_out_date = unsanitize_date(params[:search_info][:check_out])
    @policies = Policy.where(kennel_id: @searched_kennel[:id])
    @breeds_restricted = BreedRestriction.where(kennel_id: @searched_kennel[:id])
    maxed_out?
    get_amenities_offered
    get_run_price_range
    get_pickup_and_dropoff_times
  end

  def get_pickup_and_dropoff_times
    @hours_of_operation = HoursOfOperation.where(kennel_id: @searched_kennel).first
  end

  def get_run_price_range
    run_price_range = []
    @runs.each do |run|
      run_price_range << run[:price]
    end
    @run_price_range = run_price_range.sort
  end

  def maxed_out?
    @reservations = Reservation.where(kennel_id: @searched_kennel[:id], completed: "false")
    get_res_dates
  end

  def get_amenities_offered
    @amenity_ids = []
    @amenities = Amenity.where(kennel_id: @searched_kennel[:id])
    @amenities.each do |amenity|
      @amenity_ids << amenity.id
    end
  end

  def get_res_dates
    @res_ids_and_dates = []
    @reservations.each do |res|
      reservation_date_range = (res[:check_in_date]..res[:check_out_date]).map{|date| date}
      reservation_date_range.delete_at(reservation_date_range.length - 1)
      @res_ids_and_dates << [res[:id], reservation_date_range]
    end
    filter_res_dates
  end

  def filter_res_dates
    @each_date_reservation = []
    @guest_stay_date_range = (Date.parse(params[:search_info][:check_in])..Date.parse(params[:search_info][:check_out])).map{|date| date}
    @guest_stay_date_range.delete_at(@guest_stay_date_range.length - 1)
    @guest_stay_date_range.each do |gr|
      @res_ids_and_dates.each do |k|
        k[1].each do |i|
          if i == gr
            @each_date_reservation << [i, k[0]]
          end
        end
      end
    end
    group_res_dates
  end

  def group_res_dates
    id_holder = []
    @group_res_dates = []
    @guest_stay_date_range.each do |gr|
      @each_date_reservation.each do |k, v|
        if gr == k
          if @group_res_dates.empty?
            @group_res_dates << [id_holder << v, k]
          else
            @group_res_dates.each do |ke, va|
              if va == k
                ke << v
              elsif !@group_res_dates.flatten.include? k
                @group_res_dates << [id_holder << v, k]
              end
            end
          end
        end
      end
    end
    @grouped_res_dates = @group_res_dates.map {|k, v| [k.uniq, v]}
    get_number_of_runs_occupied
  end

  def get_number_of_runs_occupied
    @grouped_res_dates.each do |reservation_ids, date1|
      @runs_for_today = []
      reservation_ids.each do |res_id|
        res = Reservation.find(res_id)
        (JSON.parse res[:run_ids]).each {|i| @runs_for_today << i}
      end
      group_runs
    end
  end

  def group_runs
    @group_runs_by_count = []
    counter = @runs_for_today.length - 1
    @runs_for_today.length.times do
      if @runs_for_today.count(@runs_for_today[0]) > 1
        @group_runs_by_count << [@runs_for_today[0].to_s, @runs_for_today.count(@runs_for_today[0])]
        @runs_for_today.delete(@runs_for_today[0])
      elsif !@runs_for_today.empty?
        @group_runs_by_count << [@runs_for_today[0].to_s, 1]
        @runs_for_today.delete(@runs_for_today[0])
      end
    end
    check_if_runs_maxed_today
  end

  def check_if_runs_maxed_today
    @run_ids_maxed = []
    @group_runs_by_count.each do |run_id, count|
      run = Run.find(run_id)
      @run_ids_maxed << run_id if count == run[:number_of_rooms]
    end
  end

  def kennel_dashboard
    if !current_user.nil?
      @user = User.find(current_user.id)
      @kennel = Kennel.where(user_id: current_user.id).first
      if !@kennel.nil?
        filter_reservation_search if !params[:search_by].blank?
        reservations = Reservation.where(kennel_id: @kennel[:id])
        @reservations = reservations if !reservations.blank?
        @hours_of_operation = HoursOfOperation.where(kennel_id: @kennel[:id]).first
        week_check_array = %w(monday_open tuesday_open wednesday_open thursday_open friday_open saturday_open sunday_open)
        week_check_array.each do |weekday|
          if @hours_of_operation[weekday] != "closed"
            @changed_time = true
            break
          else
            @changed_time = false
          end
        end
        @run = Run.where(kennel_id: @kennel[:id]).first
        session[:hours_of_operation_id] = @hours_of_operation[:id]
      end
    end
    get_most_booked_runs if !@reservations.nil?
  end

  def kennel_view_pets
    @pets = []
    JSON.parse(params[:pet_ids]).each do |pet_id|
      @pets << Pet.find(pet_id)
    end
    @counter = @pets.length
  end

  def filter_reservation_search
    search_by = params[:search_by]
    @reservation_search_results = Reservation.where(search_by.to_sym => params[:reservation_search].downcase, kennel_id: @kennel[:id]).order(created_at: :desc).limit(10)
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
    @kennel = Kennel.find(params[:kennel_id]) if !params[:kennel_id].nil?
    if !params[:reservation_ids].nil?
      @current_reservations = params[:reservation_ids].map do |i|
        Reservation.find(i)
      end
      @date = []
      split_date = params[:date].split("/")
      @date << split_date[2]
      @date << split_date[0]
      @date << split_date[1]
      @date = Date.parse(@date.join("-"))
      get_reservations_checking_in_and_out
      get_all_runs
    end
  end

  def get_reservations_checking_in_and_out
    @reservations_checking_out_today = []
    @reservations_checking_in_today = []
    @current_reservations.each do |res|
      @reservations_checking_out_today << res[:id] if res[:check_out_date] == @date
      @reservations_checking_in_today << res[:id] if res[:check_in_date] == @date
    end
  end

  def get_all_runs
    all_runs = Run.where(kennel_id: @kennel[:id]).to_a
    @all_run_ids_and_quantities = []
    @all_run_ids = []
    all_runs.each do |run|
      @all_run_ids_and_quantities << [run[:id], run[:number_of_rooms]]
      @all_run_ids << run[:id]
    end
    get_runs_taken
  end

  def get_runs_taken
    runs_taken = []
    @runs_taken_ids_and_quantities = []
    @current_reservations.each do |res|
      JSON.parse(res[:run_ids]).each do |run_id|
        runs_taken << run_id
      end
    end

    runs_taken.length.times do
      count = runs_taken.count(runs_taken[0])
      @runs_taken_ids_and_quantities << [runs_taken[0], count]
      runs_taken.delete(runs_taken[0])
    end

    get_runs_available
  end

  def get_runs_available
    counter = 0
    @all_run_ids_and_quantities.each do |all_run_id, all_quantity|
      @runs_taken_ids_and_quantities.each do |taken_run_id, taken_quantity|
        if all_run_id == taken_run_id
          @all_run_ids_and_quantities[counter][1] -= taken_quantity
        end
      end
      counter += 1
    end
    add_runs_checking_out
  end

  def add_runs_checking_out
    if !@reservations_checking_out_today.blank?
      all_runs_opening_up = []
      runs_opening_ids_and_quantities = []
      @reservations_checking_out_today.each do |res_id|
        res = Reservation.find(res_id)
        JSON.parse(res[:run_ids]).each do |run_id|
          all_runs_opening_up << run_id
        end
      end
      all_runs_opening_up.length.times do
        count = all_runs_opening_up.count(all_runs_opening_up[0])
        runs_opening_ids_and_quantities << [all_runs_opening_up[0], count]
        all_runs_opening_up.delete(all_runs_opening_up[0])
      end
      counter = 0
      @all_run_ids_and_quantities.each do |all_run_id, all_quantity|
        runs_opening_ids_and_quantities.each do |open_run_id, open_quantity|
          if all_run_id == open_run_id
            @all_run_ids_and_quantities[counter][1] += open_quantity
          end
        end
        counter += 1
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
    @counter = @pets.length
  end

  private

  def kennel_params
    return params.require(:kennel).permit(:avatar, :name, :cats_or_dogs, :address, :city, :state, :zip, :phone, :email, :mission_statement, :sales_tax )
  end

end
