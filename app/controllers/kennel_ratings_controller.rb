class KennelRatingsController < ApplicationController
  before_action :authenticate_user!

  def new
    @kennel_rating = KennelRating.new
  end

  def create
    kennel_rating = KennelRating.new(kennel_rating_params)
    if params[:user_id] == current_user.id
      reservation_id = params[:kennel_rating][:reservationID]
      if KennelRating.where(reservation_id: reservationID, userID: current_user.id, kennelID: params[:kennelID]).nil?
        kennel_rating = (reservation.kennel_rating = kennel_rating)
        kennel_rating[:reservationID] = kennel_rating[:reservation_id]
        kennel_rating.save!
      else
        return redirect_to request.referrer
        false
      end
    else
      return redirect_to request.referrer
      false
    end
  end

  private

  def kennel_rating_params
    return params.require(:kennel_rating).permit(:rating, :comment, :reservationID, :kennelID, :userID)
  end

end
