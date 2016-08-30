class Search < ActiveRecord::Base
  validates :search_zip, format: { with: /\A[0-9]{5}\z/i, message: "Zip-Code requires 5 numbers." }
  validates :radius, format: { with: /\A[0-9]{0,3}\z/i, message: "Radius accepts no more than 3 numbers." }
  validates :check_in, presence: { message: "Must give a check-in date."}
  validates :check_out, presence: { message: "Must give a check-out date."}
  validates :cats_or_dogs, presence: true
  validates :number_of_dogs, format: { with: /\A[0-9]{1}\z/i }
  validates :number_of_cats, format: { with: /\A[0-9]{1}\z/i }
  validates :number_of_rooms, format: { with: /\A[0-9]{1,2}\z/i }
end
