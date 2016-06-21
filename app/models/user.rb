class User < ActiveRecord::Base
  has_one  :kennel
  has_many :customer_emergency_contacts
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
