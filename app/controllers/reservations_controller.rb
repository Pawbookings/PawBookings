class ReservationsController < ApplicationController
  def show
    @customer_email = params[:customer_email].downcase.capitalize
    @transID = params[:transID]
  end

  def new
    @reservation = Reservation.new
    @runs = []
  	@amenities = []
  	@kennel = current_user.kennel
  	@runs = @kennel.runs
  	@amenities = @kennel.amenities
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    user = User.find_by_email(params[:customer_email])
    run_ids = []
    pet_ids = []
    amenity_ids = []

    if(user.nil? || !params['room-units'].present? || params[:customer_first_name] == '' || params[:customer_last_name] == '' || params[:customer_email] == '' || params[:customer_phone] == '' || params[:month_in] == '' || params[:month_out] == '' || params[:day_in] == '' || params[:date_out] == '' || params[:year_in] == '' || params[:year_out] == '')
      all_params = [:customer_first_name, :customer_last_name, :customer_email, :customer_phone, :month_in, :month_out, :day_in, :date_out, :year_in, :year_out]
      error_message = []
      all_params.each do |par|
        if params[par] == ''
          error_message << par
        end
      end
      error_message << 'user' if user == nil
      error_message << 'room-unit' if !params['room-units'].present?
      return redirect_to kennel_dashboard_path(reservation: error_message)
    end

    if (!Date.valid_date? params[:year_in].to_i, params[:month_in].to_i, params[:day_in].to_i) || (!Date.valid_date? params[:year_out].to_i, params[:month_out].to_i, params[:day_out].to_i)
      return redirect_to kennel_dashboard_path(reservation: 'dates')
    end

    check_in_date_params = params[:month_in] + '/' +params[:day_in] +'/' + params[:year_in]
    check_out_date_params = params[:month_out] + '/' +params[:day_out] +'/' + params[:year_out]
    dates = [Date.strptime(check_in_date_params,"%m/%d/%Y"), Date.strptime(check_out_date_params,"%m/%d/%Y")]

    @kennel = current_user.kennel
    run_ids = params["room-units"] if params["room-units"].present?
    if params["pet_name"].present? && params["pet_type"]
      npet = user.pets.create!(name: params["pet_name"], cat_or_dog: params["pet_type"], weight: "1", vaccinations: "false", spay_or_neutered: "neutered")
      pet_ids = [npet.id.to_s] 
    elsif params["pets"].present?
      pet_ids = params["pets"] 
    end

    reserved_dates = @kennel.reservations.where(completed: "false").pluck(:check_in_date, :check_out_date, :run_ids)
    reservations_same_date_for_run = 0
    reserved_dates.each do |rdate|
      rids = rdate[2].tr('[]', '').split(',').map(&:to_i)
      ru = params["room-units"].map(&:to_i).flatten.try(:first)
      actual_run = Run.find_by_id(ru)
      available_runs_for_the_date = 0
      if actual_run.present?
        available_runs_for_the_date = actual_run.number_of_rooms
      end
      trythis = false
      if (rdate[0] <= dates.last) && (rdate[0] >= dates.first) && (rids.include?(ru))
        trythis = true
        reservations_same_date_for_run = reservations_same_date_for_run + 1
      end

      if reservations_same_date_for_run >= available_runs_for_the_date && trythis
        flash[:notice] = "There is already a reservation for this date! Kindly check your reservations."
        redirect_to :back and return false
      end
    end

  amenity_ids = params["amenities"] if params["amenities"].present?
  days = 0
  days = (dates.last - dates.first).to_i
  days = 1 if days == 0
  total_price_without_tax = 0
  if run_ids.present?
    run_prices = @kennel.runs.where(id: run_ids.map(&:to_i)).pluck(:price)
    run_prices.each do |pr|
      total_price_without_tax = total_price_without_tax + (pr*days)
    end
    room_details = []
    run_objs = @kennel.runs.where(id: run_ids.map(&:to_i))
    run_objs.each do |ro|
      room_details << [ro.title, ro.price]
    end

  end

  if amenity_ids.present?
    amenity_prices = @kennel.amenities.where(id: amenity_ids.map(&:to_i)).pluck(:price)
    amenity_prices.each do |pr|
      total_price_without_tax = total_price_without_tax + (pr*days)
    end

    amenity_details = []
    ads = @kennel.amenities.where(id: amenity_ids.map(&:to_i))
    ads.each do |ad|
      amenity_details << [ad.title, ad.price]
    end
  end
  tax_percentage = @kennel.sales_tax
  tax_total_price = (total_price_without_tax*tax_percentage/100).round(2)
  total_price = (tax_total_price+total_price_without_tax).round(2)
  reservation = @kennel.reservations.build(
                                user_id: user.id,
                                check_in_date: dates.first,
                                check_out_date: dates.last,
                                room_details: room_details.to_s,
                                amenity_details: amenity_details.to_s,
                                total_price_without_tax: total_price_without_tax,
                                tax_percentage: tax_percentage,
                                tax_total_price: tax_total_price,
                                total_price: total_price,
                                payment_first_name: "old",
                                payment_last_name: "reservation",
                                customer_first_name: params[:customer_first_name].downcase,
                                customer_last_name: params[:customer_last_name].downcase,
                                customer_email: params[:customer_email].downcase,
                                customer_phone: params[:customer_phone].scan(/\d/).join,
                                pet_ids: pet_ids.map(&:to_i).to_s,
                                run_ids: run_ids.map(&:to_i).to_s,
                                amenity_ids: amenity_ids.map(&:to_i).to_s,
                                transID: "old12345",
                                card_number: "0000",
                                expiration_date: nil,
                                completed: "false",
                                checked_in: "false",
                                checked_out: "false",
                                three_weeks_before_email_reminder: "false",
                                one_week_before_email_reminder: "false",
                                day_before_email_reminder: "false",
                                kennelID: @kennel.id,
                                userID: user.id)
    if reservation.save
      reservation.update(reservationID: reservation.id)
      UserMailer.reservation_confirmation(reservation[:id], total_price.to_s).deliver_now
      flash[:notice] = "Reservation Saved in the System!"
      redirect_to kennel_dashboard_path(reservation: nil)
    else
      error_message = []
      reservation.errors.each do |attr,err|
        error_message << attr
      end
      redirect_to kennel_dashboard_path(reservation: error_message.uniq)
    end
  end

  def get_pets
  	@pets = []
  	@u = User.find_by_email(params[:email])
    if @u.present?
  	  @pets = @u.pets
    else
      if params[:email].present? && params[:customer_first_name].present? && 
          params[:customer_last_name].present? && params[:customer_phone].present?

          User.create!(email: params[:email], 
                   first_name: params[:customer_first_name], 
                   last_name: params[:customer_last_name], 
                   phone: params[:customer_phone].scan(/\d/).join, 
                   password: "12345678Paw!", 
                   password_confirmation: "12345678Paw!", 
                   kennel_or_customer: "customer")
      else
        @error_msg = "Enter pet owner's all details"
      end
    end 

  	return render partial: "reservations/get_pets"
  end
end
