class CustomerEmergencyContact < ActiveRecord::Base
  belongs_to :user

  validates :name, presence: true
  validates :email, presence: true
  validates :phone, presence:true, :numericality => true,
  :length => { :minimum => 10, :maximum => 15 }
end
