class CustomerEmergencyContact < ActiveRecord::Base
  has_many   :pets
  belongs_to :user
end
