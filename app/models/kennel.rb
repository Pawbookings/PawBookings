class Kennel < ActiveRecord::Base
  belongs_to :user
  has_many :runs
  has_many :amenities
  has_many :policies
end
