class CsvKennelsController < ApplicationController

  def show
    @kennel = Kennel.find(params[:id])
  end

  def notify_kennel
    kennel = Kennel.find(params[:id])
    user = User.find(kennel[:user_id])
    UserMailer.notify_kennel_email(kennel[:id], user[:id]).deliver_now
    flash[:notice] = "The Kennel has been successfully notified!"
    return redirect_to request.referrer
  end

  def claim_business
    @kennel = Kennel.find(params[:id])
  end

  def send_business_claim
    UserMailer.send_business_claim_email(params[:id], params[:name], params[:email], params[:phone]).deliver_now
    flash[:notice] = "Your claim has been sent!"
    return redirect_to request.referrer
  end
end
