class Kennel < ActiveRecord::Base
  belongs_to :user
  has_one    :kennel_check_in_check_out
  has_one    :sales_tax
  has_one    :hours_of_operation
  has_many   :holidays
  has_many   :runs
  has_many   :amenities
  has_many   :policies
  has_many   :photos
  has_many   :reservations
  has_many   :stand_by_reservations
  has_many   :users, through: :reservations

  validates :name, format: { with: /\A[a-z\s-]{3,30}\z/i }
  validates :address, length: { minimum: 3 }
  validates :mission_statement, presence: true
  validates :city, format: { with: /\A[a-z\s-]{3,30}\z/i }
  validates :state, presence: true
  validates :zip, format: { with: /\A[0-9]{5}\z/i }
  validates :phone, format: { with: /\A\+?[0-9]{,2}(-|\s)?\(?[0-9]{3}\)?(-|\s)?[0-9]{3}(-|\s)?[0-9]{4}\z/ }
  validates :email, uniqueness: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :cats_or_dogs, presence: true

  geocoded_by :zip
  after_validation :geocode

  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
end
