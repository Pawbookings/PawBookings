class User < ActiveRecord::Base
  has_one  :kennel
  has_one  :customer_vet_info
  has_one  :customer_emergency_contact
  has_many :visits
  has_many :photos
  has_many :pets
  has_many :payments
  has_many :reservations
  has_many :kennels, through: :reservations
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_attached_file :user_image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/assets/default_testimonial_image.jpg"
  validates_attachment_content_type :user_image, content_type: /\Aimage\/.*\Z/
end
