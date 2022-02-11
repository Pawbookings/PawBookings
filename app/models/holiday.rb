class Holiday < ApplicationRecord
  belongs_to :kennel

  validates :holiday_date, presence: true
  validates :description, length: { maximum: 150 }, presence: true
end
