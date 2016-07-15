class User < ActiveRecord::Base
  has_one  :kennel
  has_many :visits
  has_many :customer_emergency_contacts
  has_many :pets
  has_many :payments
  has_many :reservations
  has_many :kennels, through: :reservations
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
