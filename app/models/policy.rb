class Policy < ActiveRecord::Base
  belongs_to :kennel
  validates :description, presence: true
end
