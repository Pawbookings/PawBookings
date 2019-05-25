class ContactMessagesController < ApplicationController
  def new
    @contact_message = ContactMessage.new
  end

  def create
    contact_message = ContactMessage.new(contact_message_params)
    if contact_message.save && verify_recaptcha(model: contact_message)
      UserMailer.pawbookings_support_email(contact_message).deliver_now
      redirect_to message_confirmation_path
    else
      redirect_to request.referrer
    end

  end

  private

  def contact_message_params
    params.require(:contact_message).permit(:name, :phone, :email, :subject, :details)
  end
end
