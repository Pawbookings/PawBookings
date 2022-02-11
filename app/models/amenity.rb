class Amenity < ApplicationRecord
  belongs_to :kennel

  validates :title, presence: true
  validates :description, length: { maximum: 150 }, presence: true
  validates_numericality_of :price
end
