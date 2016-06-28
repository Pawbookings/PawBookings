class HomeController < ApplicationController
  def index
    if !current_user.nil? && current_user.kennel_or_customer == "kennel"
        return redirect_to kennel_dashboard_path
    elsif !current_user.nil? && current_user.kennel_or_customer == "customer"
        return redirect_to customer_dashboard_path
    else
      return root_path
    end
  end

end
