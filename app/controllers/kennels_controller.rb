class KennelsController < ApplicationController
  before_action :authenticate_user!

  def new
    @kennel = Kennel.new
  end

  def create
    @kennel = Kennel.new(kennel_params)
    @user = User.where(id: current_user.id).first
    if !kennel_completed_registration? && @kennel.save && @user.kennel = @kennel
      UserMailer.new_kennel_registration(current_user).deliver_now
      @user.completed_registration = true
      @user.save
      redirect_to kennel_dashboard_path
    else
      flash[:notice]
      redirect_to kennel_dashboard_path
    end
  end

  def kennel_dashboard
    if !current_user.nil?
      @kennel = Kennel.where(user_id: current_user.id).first
      if !@kennel.nil?
        reservations = Reservation.where(kennel_id: @kennel[:id])
        @reservations = reservations if !reservations.blank?
        # @photo = Photo.where(kennel_id: @kennel.id).first
      end
    end
  end

  def kennel_reservations
    get_reservations_info
    pets_going_home?
    get_all_runs
  end

  def get_all_runs
    @runs = Run.where(kennel_id: params["kennel_id"].to_i)
  end

  def pets_going_home?
    @pets_going_home = []
    @pets.each do |pi|
      if pi[:check_out] == params[:date]
        @pets_going_home << [pi[:id], pi[:check_out]]
      end
    end

    if !@pets_going_home.blank?
      @runs_becoming_available = []
      @run_names = []
      @pets_going_home.each do |k, v|
        pet = Pet.find(k)
        user = User.where(id: pet[:user_id]).first
        v = Date.parse(sanitize_date(v))
        reservation = Reservation.where(kennel_id: params[:kennel_id], user_id: user[:id], check_out: v, completed: nil).first
        JSON.parse(reservation[:run_ids]).each do |ri|
          @runs_becoming_available << ri
        end
        counter = 0
        @runs_becoming_available.each do |ra|
          run = Run.find(ra)
          if !@run_names.flatten.include? run[:title]
            @run_names << [run[:title], counter += 1]
          else
            @run_names = @run_names.map do |ke, va|
              if ke == run[:title]
                [run[:title], va += 1]
              end
            end
          end
        end
        @runs_becoming_available = []
      end
    end
  end

  def get_reservations_info
    @runs_maxed_today = []
    @runs_with_days_left = []
    @pets = []
    all_run_ids = []
    all_pets = []
    check_in = []
    unless params[:reservation_ids].nil?
      params[:reservation_ids].each do |ri|
        reservation = Reservation.find(ri.to_i)
        check_in << reservation[:check_in]
        JSON.parse(reservation[:run_ids]).each do |r|
          all_run_ids << r
        end
        JSON.parse(reservation[:pet_ids]).each do |pi|
          all_pets << [pi, reservation[:check_in], reservation[:check_out]]
        end
      end

      all_run_ids.length.times do
        number_of_rooms = all_run_ids.count(all_run_ids[0])
        run = Run.find(all_run_ids[0])
        if run[:number_of_rooms] == number_of_rooms
          @runs_maxed_today << run.title
        else
          @runs_with_days_left << [run.title, (run.number_of_rooms - number_of_rooms)]
        end
        all_run_ids.delete(all_run_ids[0])
        break if all_run_ids.blank?
      end

      all_pets.each do |pi, rci, rco|
        pet = Pet.find(pi)
        @pets << {user_id: pet[:user_id], id: pet[:id], name: pet[:name], cat_or_dog: pet[:cat_or_dog], breed: pet[:breed], weight: pet[:weight], check_in: unsanitize_date(rci.to_s), check_out: unsanitize_date(rco.to_s)}
      end
    else
      @no_reservations = true
    end
  end

  def kennel_reservation_pet_owner_info
    @user = User.find(params[:id])
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
    return params.require(:kennel).permit(:avatar, :kennel_name, :cats_or_dogs, :kennel_address, :city, :state, :zip, :phone, :mission_statement )
  end

end
