class SearchesController < ApplicationController
  include SearchesHelper
  def search_results
    sanitize_date(params[:check_in])
    params[:check_in] = Date.parse(@new_date)

    sanitize_date(params[:check_out])
    params[:check_out] = Date.parse(@new_date)

    get_pet_stay_dates

    location_filtering
    pet_type_filtering
    holiday_filtering
    hours_of_operation_filtering
  end

  def get_pet_stay_dates
    @pet_stay_date_range = (params[:check_in]..params[:check_out]).map{|date| date}
    params[:number_of_nights] = @pet_stay_date_range.count.to_s
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
    @kennels_that_are_closed.each {|k| @negative_kennels << k }
    @kennels_that_are_closed.each do |k|
      @holiday_filtered_results.each do |fr|
        @holiday_filtered_results.delete fr if k === fr
      end
    end
    @final_search_results = @holiday_filtered_results
  end

  def show
    @searched_kennel = Kennel.find(params[:id])
    @kennel_user = User.find(@searched_kennel[:user_id])
    @runs = Run.where(kennel_id: @searched_kennel.id)
    @customer_drop_off_date = unsanitize_date(params[:search_info][:check_in])
    @customer_pick_up_date = unsanitize_date(params[:search_info][:check_out])
    maxed_out?
  end

  def maxed_out?
    @reservations = Reservation.where(kennel_id: @searched_kennel[:id], completed: nil)
    get_res_dates
  end

  def get_res_dates
    @res_ids_and_dates = []
    @reservations.each do |res|
      reservation_date_range = (res[:check_in]..res[:check_out]).map{|date| date}
      reservation_date_range.delete_at(reservation_date_range.length - 1)
      @res_ids_and_dates << [res[:id], reservation_date_range]
    end
    filter_res_dates
  end

  def filter_res_dates
    @each_date_reservation = []
    @guest_stay_date_range = (params[:search_info][:check_in]..params[:search_info][:check_out]).map{|date| date}
    @guest_stay_date_range.delete_at(@guest_stay_date_range.length - 1)
    @guest_stay_date_range.each do |gr|
      @res_ids_and_dates.each do |k|
        k[1].each do |i|
          if i == Date.parse(gr)
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
    @grouped_res_dates = @group_res_dates.map do |k, v|
      [k.uniq, v]
    end
    get_number_of_runs_occupied
  end

  def get_number_of_runs_occupied
    @runs_taken = []
    @grouped_res_dates.each do |k, v|
      k.each do |i|
        reservation = Reservation.find(i)
        run_ids = []
        run_ids << JSON.parse(reservation[:run_ids])
        run_ids.flatten.each do |rid|
          run = Run.find(rid)
          if @runs_taken.empty?
            @runs_taken << [rid, 1, run[:number_of_rooms]]
          else
            @runs_taken = @runs_taken.map do |ke, va|
              if ke == rid
                [rid, va += 1, run[:number_of_rooms]]
              else
                @runs_taken << [rid, 1, run[:number_of_rooms]]
              end
            end
          end
        end
      end
      check_if_runs_maxed
    end
  end

  def check_if_runs_maxed
    @run_ids_maxed = []
    @runs_taken.each do |rid, counter, total_rooms|
      @run_ids_maxed << rid if counter == total_rooms
    end
  end

end
