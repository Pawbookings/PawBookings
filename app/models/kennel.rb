class Kennel < ActiveRecord::Base
  belongs_to :user
  has_one    :drop_off_pick_up
  has_one    :hours_of_operation
  has_many   :holidays
  has_many   :runs
  has_many   :amenities
  has_many   :policies
  has_many   :photos
  has_many   :reservations
  has_many   :users, through: :reservations

  geocoded_by :zip
  after_validation :geocode

  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
end
