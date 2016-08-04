class PawbookingsAdminsController < ApplicationController
  http_basic_authenticate_with name: "pawbookings", password: "helloworld"

  def index
  end
end
