class Holiday < ActiveRecord::Base
  belongs_to :kennel

  validates :holiday_date, presence: true
  validates :description, length: { maximum: 150 }
end
