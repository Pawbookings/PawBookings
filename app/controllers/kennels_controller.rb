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

  def kennel_view_pets
    @pets = []
    JSON.parse(params[:pet_ids]).each do |pet_id|
      @pets << Pet.find(pet_id)
    end
    @counter = @pets.length
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
