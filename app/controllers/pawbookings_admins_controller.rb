class PawbookingsAdminsController < ApplicationController
  before_action :authenticate_user!
  http_basic_authenticate_with name: "pawbookings", password: ENV["pawbookings_password"]

  def index
  end
end
