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
    if params[:no_params].nil?
      if params[:number_of_dogs] == "0" && params[:number_of_cats] == "0"
        flash[:notice] = "Must select number of dogs or cats greater than 0."
        return redirect_to request.referrer
      end

      @final_search_results = []
      get_pet_stay_dates
      location_filtering
      pet_type_filtering
      # holiday_filtering
      hours_of_operation_filtering
      check_if_runs_listed
    end
  end

  def get_pet_stay_dates
    @pet_stay_date_range = (Date.parse(params[:check_in])..Date.parse(params[:check_out])).map{|date| date}
    params[:number_of_nights] = (@pet_stay_date_range.count.to_i - 1) > 0 ? (@pet_stay_date_range.count.to_i - 1) : 1
  end

  def location_filtering
    params[:radius] = "5" if params[:radius].blank?
    @relevant_locations = Kennel.where(taken_ownership: true).near(params[:search_zip], params[:radius]).to_a
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

  # def holiday_filtering
  #   @kennels_with_holidays = []
  #   @pet_type_filtered_results.each do |fr|
  #     kennel = Kennel.find(fr.id)
  #     holidays = Holiday.where(kennel_id: kennel[:id])
  #     holidays.each do |h|
  #       @pet_stay_date_range.each { |ps| @kennels_with_holidays << kennel if ps === h.holiday_date }
  #     end
  #   end
  #   @negative_kennels = @kennels_with_holidays
  #   @kennels_with_holidays.each do |k|
  #     @pet_type_filtered_results.each do |pt|
  #       @pet_type_filtered_results.delete pt if pt === k
  #     end
  #   end
  #   @holiday_filtered_results = @pet_type_filtered_results
  # end

  def hours_of_operation_filtering
    @kennels_that_are_closed = []
    @pet_type_filtered_results.each do |fr|
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
      @pet_type_filtered_results.each do |fr|
        @pet_type_filtered_results.delete fr if k === fr
      end
    end
    @hours_of_operation_results = @pet_type_filtered_results
  end

  def check_if_runs_listed
    @hours_of_operation_results.each do |hr|
      runs = Run.where(kennel_id: hr.id)
      @final_search_results << hr if !runs.empty?
    end
    get_csv_kennels
  end

  def get_csv_kennels
    relevant_locations = Kennel.near(params[:search_zip], params[:radius]).where(taken_ownership: false).reverse.to_a
    relevant_locations.each do |rl|
      @final_search_results << rl
    end
    @final_search_results.reverse!
  end

end
