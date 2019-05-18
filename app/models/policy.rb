class Policy < ActiveRecord::Base
  belongs_to :kennel
  validates :title, presence: true
  validates :description, presence: true
end
