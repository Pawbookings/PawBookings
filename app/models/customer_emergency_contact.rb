class CustomerEmergencyContact < ActiveRecord::Base
  belongs_to :user

  validates :name, presence: true
  validates :email, presence: true
  validates :phone, presence: true
end
