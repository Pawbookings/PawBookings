class SearchesController < ApplicationController
  def search_results
    location_filtering
    holiday_filtering
    @params = params
  end

  def location_filtering
    @filtered_results = []
    @search_results = Kennel.near(params[:search_zip], params[:radius]).to_a
    @search_results.each do |sr|
      @filtered_results << sr if sr.cats_or_dogs == "both" || sr.cats_or_dogs.include? params[:pet_type]
    end
    @filtered_results
  end

  def holiday_filtering
    @holiday_filtered_results = []
    @filtered_results.each do |fr|
      @kennel = Kennel.find(fr.id)
      @holidays = Holiday.where(kennel_id: @kennel[:id])
      
    end
  end

  def show
    @searched_kennel = Kennel.where(id: params[:id])
    @amenities = Amenity.where(kennel_id: @searched_kennel[:id])
  end
end
