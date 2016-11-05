class SearchesController < ApplicationController
  skip_before_action :verify_authenticity_token
  include SearchesHelper

  def create
    dates_split = params[:reservation_dates].split(" ")
    params[:check_in] = dates_split[0]
    params[:check_out] = dates_split[2]
    if (params[:number_of_dogs].to_i > 0) && (params[:number_of_cats].to_i == 0)
      params[:cats_or_dogs] = "dogs"
    elsif (params[:number_of_dogs].to_i == 0) && (params[:number_of_cats].to_i > 0)
      params[:cats_or_dogs] = "cats"
    else
      params[:cats_or_dogs] = "both"
    end
    search = Search.new

    sanitize_date(params[:check_in])
    params[:check_in] = Date.parse(@new_date)
    sanitize_date(params[:check_out])
    params[:check_out] = Date.parse(@new_date)

    search.search_zip = params[:search_zip].to_i
    search.radius = params[:radius].to_i
    search.check_in = params[:check_in]
    search.check_out = params[:check_out]
    search.cats_or_dogs = params[:cats_or_dogs]
    search.number_of_dogs = params[:number_of_dogs].to_i
    search.number_of_cats = params[:number_of_cats].to_i
    search.number_of_rooms = params[:number_of_rooms].to_i
    if search.valid? && search.save!
      redirect_to search_results_path(params)
    else
      flash[:notice] = search.errors.messages.values.flatten[0].to_s
      redirect_to request.referrer
    end
  end

  def search_results
    if params[:number_of_dogs] == "0" && params[:number_of_cats] == "0"
      flash[:notice] = "Must select number of dogs or cats greater than 0."
      redirect_to request.referrer
    end

    @final_search_results = []
    get_pet_stay_dates
    location_filtering
    pet_type_filtering
    holiday_filtering
    hours_of_operation_filtering
    check_if_runs_listed
  end

  def show
    @searched_kennel = Kennel.find(params[:id])
    @kennel_user = User.find(@searched_kennel[:user_id])
    @runs = Run.where(kennel_id: @searched_kennel.id)
    @customer_check_in_date = unsanitize_date(params[:search_info][:check_in])
    @customer_check_out_date = unsanitize_date(params[:search_info][:check_out])
    maxed_out?
    get_amenities_offered
  end

  def maxed_out?
    @reservations = Reservation.where(kennel_id: @searched_kennel[:id], completed: nil)
    get_res_dates
  end

  def get_amenities_offered
    @amenity_ids = []
    @amenities = Amenity.where(kennel_id: params[:id])
    @amenities.each do |amenity|
      @amenity_ids << amenity.id
    end
  end

  def get_pet_stay_dates
    @pet_stay_date_range = (Date.parse(params[:check_in])..Date.parse(params[:check_out])).map{|date| date}
    params[:number_of_nights] = (@pet_stay_date_range.count.to_i - 1) > 0 ? (@pet_stay_date_range.count.to_i - 1) : 1
  end

  def location_filtering
    params[:radius] = 5 if params[:radius].blank?
    @relevant_locations = Kennel.near(params[:search_zip], params[:radius]).to_a
  end

  def pet_type_filtering
    @pet_type_filtered_results = []
    @relevant_locations.each do |rl|
      if params[:cats_or_dogs] == "both"
        @pet_type_filtered_results = @relevant_locations
      else
        if rl.cats_or_dogs == "both" || rl.cats_or_dogs == params[:cats_or_dogs]
          @pet_type_filtered_results << rl
        end
      end
    end
  end

  def holiday_filtering
    @kennels_with_holidays = []
    @pet_type_filtered_results.each do |fr|
      kennel = Kennel.find(fr.id)
      holidays = Holiday.where(kennel_id: kennel[:id])
      holidays.each do |h|
        @pet_stay_date_range.each { |ps| @kennels_with_holidays << kennel if ps === h.holiday_date }
      end
    end
    @negative_kennels = @kennels_with_holidays
    @kennels_with_holidays.each do |k|
      @pet_type_filtered_results.each do |pt|
        @pet_type_filtered_results.delete pt if pt === k
      end
    end
    @holiday_filtered_results = @pet_type_filtered_results
  end

  def hours_of_operation_filtering
    @kennels_that_are_closed = []
    @holiday_filtered_results.each do |fr|
      kennel = Kennel.find(fr.id)
      hours_of_operation = HoursOfOperation.where(kennel_id: kennel[:id])
      @kennels_that_are_closed << kennel if hours_of_operation.empty?
      hours_of_operation.to_a.each do |h|
        counter = 0
        @pet_stay_date_range.each do |ps|
          days_of_week.each do |num, day|
            counter += 1 if ps.wday.to_s == num && h.send(day) == "closed"
          end
        end
        @kennels_that_are_closed << kennel if counter > 0
      end
    end
    @kennels_that_are_closed.each do |k|
      @negative_kennels << k
      @holiday_filtered_results.each do |fr|
        @holiday_filtered_results.delete fr if k === fr
      end
    end
    @hours_of_operation_results = @holiday_filtered_results
    @final_search_results = @holiday_filtered_results
  end

  def check_if_runs_listed
    @hours_of_operation_results.each do |hr|
      run = Run.where(kennel_id: hr.id)
      @final_search_results << hr if !run.empty?
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
        if Date.parse(gr) == k
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

end
