class CustomerVetInfo < ActiveRecord::Base
  belongs_to :user

  validates :name, length: { maximum: 50 }, presence: true
  validates :address, length: { minimum: 3 }, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, presence: true
  validates :phone, :emergency_phone, :presence => true,
                 :numericality => true,
                 :length => { :minimum => 10, :maximum => 15 }
end
