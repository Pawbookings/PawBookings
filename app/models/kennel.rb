class Kennel < ActiveRecord::Base
  belongs_to :user
  has_one    :drop_off_pick_up
  has_many   :runs
  has_many   :amenities
  has_many   :policies
end
