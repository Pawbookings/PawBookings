class ReservationsController < ApplicationController
  def reservation_run_info
    @run = Run.where(id: params[:run_selected]).to_a.first
    @kennel = Kennel.find(@run.kennel_id)
    @pets = Pet.where(kennel_id: @kennel.id)
  end

  def reservation_summary
  end
end
