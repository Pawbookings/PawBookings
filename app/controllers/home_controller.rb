class HomeController < ApplicationController
  def index
    if !current_user.nil? && completed_registration?
      if current_user.kennel_or_customer == "kennel"
        return redirect_to kennel_dashboard_path
      elsif current_user.kennel_or_customer == "customer"
        return redirect_to customer_dashboard_path
      end
    elsif !current_user.nil? && current_user.kennel_or_customer == "kennel"
      return redirect_to new_kennel_path
    end
  end

end
