class ReservationsController < ApplicationController
  def show
    @customer_email = params[:customer_email].downcase.capitalize
    @transID = params[:transID]
  end

  def old_reservations
  	# debugger

  	@runs = []
  	@amenities = []
  	@kennel = current_user.kennel
  	@runs = @kennel.runs
  	@amenities = @kennel.amenities
  end

  def save_old_reservations
    # return render json: params.inspect
  	# debugger




  	# @total_price = 0
   #  @total_price_without_tax = 0
   #  @tax_amount = 0
   #  counter = 1
   #  params.each_pair do |k, v|
   #    if (k.to_s.include? "total_price") || ((k.to_s.include? "room") && (k.to_s.include? "price"))
   #      @total_price += v.to_f
   #      if params["room_#{counter}_price"].to_f.to_s.length < 5 && params["room_1_price"].to_f.to_s.last == "0"
   #        params["room_#{counter}_price"] = params["room_#{counter}_price"].to_f.to_s.split("").append("0").join("")
   #      end
   #    end
   #  end
   #  number_of_nights = @kennel_info.nil? ? params["number_of_nights"] : @kennel_info["number_of_nights"]
   #  @total_price = @total_price * number_of_nights.to_i
   #  if params[:amenities_total].nil?
   #    params[:amenities_total] = @amenities_total
   #  end
   #  if params[:amenities_total] == 0
   #    @total_price_without_tax = @total_price
   #  else
   #    @total_price_without_tax = @total_price + params[:amenities_total].to_f
   #    @total_price += params[:amenities_total].to_f
   #  end
   #  @tax_amount = (@total_price * (params[:kennel_sales_tax].to_f * 0.01)).round(2)
   #  @total_price += @tax_amount
   #  @total_price = @total_price.round(2)
   #  if @total_price.to_s.length < 5
   #    @total_price = @total_price.to_s.split("").append("0").join("")
   #  end
   #  @total_price_without_tax = @total_price_without_tax.round(2)
   #  if @total_price_without_tax.to_s.length < 5
   #    @total_price_without_tax = @total_price_without_tax.to_s.split("").append("0").join("")
   #  end


     	# {"utf8"=>"✓", "authenticity_token"=>"A4aQlMrnDFJVeINbszPofQA9hSh9qq5nFG7rFNqQNuzq+wm/R25wLrzl0z3sNZBDOcNkxbEtJWnOxgGaiRZiNg==", "customer_first_name"=>"", "customer_last_name"=>"", "customer_email"=>"petowner1@yahoo.com", "customer_phone"=>"", "pets"=>["5"], "room-units"=>["5", "6"], "reservation_dates"=>"07/02/2018 - 07/02/2018", "amenities"=>["2", "3"], "commit"=>"Save", "controller"=>"reservations", "action"=>"save_old_reservations"}
  	# return render json: params.inspect

  	# params["room-units"].map(&:to_i)
  	# params["room-units"].map(&:to_i)





    user = User.find_by_email(params[:customer_email])
    run_ids = []
    pet_ids = []
    amenity_ids = []
    #.strftime('%Y-%d-%m')
    dates = params[:reservation_dates].split(" - ").map{|b| Date.strptime(b,"%m/%d/%Y")}

    @kennel = current_user.kennel

    run_ids = params["room-units"] if params["room-units"].present?
    
    if params["pet_name"].present? && params["pet_type"]
      npet = user.pets.create!(name: params["pet_name"], cat_or_dog: params["pet_type"], weight: "1", vaccinations: "false", spay_or_neutered: "neutered")
      pet_ids = [npet.id.to_s] 
    elsif params["pets"].present?
      pet_ids = params["pets"] 
    end

    reserved_dates = @kennel.reservations.where(completed: "false").pluck(:check_in_date, :check_out_date, :run_ids)

    reserved_dates.each do |rdate|
      # if ( dates.first <= rdate[0] && rdate[0] >= dates.last ) ||
      rids = rdate[2].tr('[]', '').split(',').map(&:to_i)
      ru = params["room-units"].map(&:to_i).flatten.try(:first)
      # puts "============================================="
      # puts rdate.inspect
      # puts rids.inspect
      # puts ru.inspect
      # puts (rdate[0] <= dates.last) && (rdate[0] >= dates.first) && (rids.include?(ru))
      # puts "----------------------------------------------"
      if (rdate[0] <= dates.last) && (rdate[0] >= dates.first) && (rids.include?(ru))
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
                                 customer_phone: params[:customer_phone],
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
                                 day_before_email_reminder: "false")
      if reservation.valid?

        # reservation = Reservation.where(customer_email: params[:customer_email].downcase).first
        reservation.kennelID = reservation[:kennel_id]
        reservation.userID = reservation[:user_id]
        reservation.reservationID = reservation[:id]
        reservation.save!
        UserMailer.reservation_confirmation(reservation[:id], total_price.to_s).deliver_now
        flash[:notice] = "Reservation Saved in the System!"
      end
      redirect_to :back
  end

  def get_pets
  	# puts params.inspect
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
                   phone: params[:customer_phone], 
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
