class CustomerVetInfo < ActiveRecord::Base
  belongs_to :user

  validates :name, length: { maximum: 50 }
  validates :email, presence: true
  validates :address, length: { minimum: 3 }
  validates :phone, presence: true
  validates :emergency_phone, presence: true
end
