class ReservationsController < ApplicationController
  def show
    @customer_email = params[:customer_email].downcase.capitalize
    @transID = params[:transID]
  end
end
