class BreedRestriction < ActiveRecord::Base
  belongs_to :kennel

  validates :breed, presence: true
end
