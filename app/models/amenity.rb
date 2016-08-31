class Amenity < ActiveRecord::Base
  belongs_to :kennel

  validates :title, format: { with: /\A[a-z\s-]{3,30}\z/i }
  validates :description, length: { maximum: 150 }
  validates_numericality_of :price
end
