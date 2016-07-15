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
  end

end
