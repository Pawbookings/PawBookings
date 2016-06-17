class UserMailer < ApplicationMailer
  def new_kennel_registration(current_user)
    @current_user = current_user
    mail(to: current_user.email, subject: 'Kennel Registration Confirmation')
  end
end
