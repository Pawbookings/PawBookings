class CustomerEmergencyContact < ActiveRecord::Base
  belongs_to :user

  validates :name, format: { with: /\A[a-z\s-]{3,30}\z/i }
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :phone, format: { with: /\A\+?[0-9]{,2}(-|\s)?\(?[0-9]{3}\)?(-|\s)?[0-9]{3}(-|\s)?[0-9]{4}\z/ }
end
