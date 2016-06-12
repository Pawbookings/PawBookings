class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def completed_registration?
    return true if current_user.completed_registration == true
    false
  end
end
