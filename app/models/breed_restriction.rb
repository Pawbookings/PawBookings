class BreedRestriction < ApplicationRecord
  belongs_to :kennel

  validates :breed, presence: true
end
