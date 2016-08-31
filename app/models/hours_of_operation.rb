class HoursOfOperation < ActiveRecord::Base
  belongs_to :kennel
  validates :monday_open, presence: true
  validates :monday_close, presence: true
  validates :tuesday_open, presence: true
  validates :tuesday_close, presence: true
  validates :wednesday_open, presence: true
  validates :wednesday_close, presence: true
  validates :thursday_open, presence: true
  validates :thursday_close, presence: true
  validates :friday_open, presence: true
  validates :friday_close, presence: true
  validates :saturday_open, presence: true
  validates :saturday_close, presence: true
  validates :sunday_open, presence: true
  validates :sunday_close, presence: true
end
