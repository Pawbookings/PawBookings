# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

user = User.create!(first_name: "Christopher", last_name: "Pelnar", email: 'christopherpelnar@gmail.com', password: 'helloworld', password_confirmation: 'helloworld', phone: '4074081234', time_zone: 'Eastern Time (US & Canada)', kennel_or_customer: 'kennel')
user.userID = user[:id]
user.save!

user = User.create!(first_name: "John", last_name: "Smith", email: 'johnsmith@gmail.com', password: 'helloworld', password_confirmation: 'helloworld', phone: '4078464231', time_zone: 'Eastern Time (US & Canada)', kennel_or_customer: 'customer')
user.userID = user[:id]
user.save!

kennel = Kennel.create!(user_id: 1, name: 'Kennel One', zip: '34741', address: '123 Fake St', city: 'Kissimme', state: 'FL', cats_or_dogs: "both")
kennel.kennelID = kennel[:id]
kennel.userID = kennel[:user_id]
kennel.save!

user = User.create!(first_name: "Patrick", last_name: "McDonnel", email: 'pawbookings@gmail.com', password: 'helloworld', password_confirmation: 'helloworld', phone: '4078464231', time_zone: 'Eastern Time (US & Canada)', kennel_or_customer: 'admin')
user.userID = user[:id]
user.save!

Run.create!(kennel_id: 1, size_width: '12', size_length: '12', title: 'The Large Room', description: 'The largest room we have', indoor_or_outdoor: 'indoor', pets_per_run: 2, price: 90.0, weight_limit: 120, breeds_restricted: 'n/a', number_of_rooms: 2, type_of_pets_allowed: 'dog' )

Pet.create!(user_id: 2, name: "Petey", cat_or_dog: "dog", breed: "Pitbull", weight: "120", vaccinations: "true", spay_or_neutered: "true", special_instructions: "Likes to have belly scratched.")
Pet.create!(user_id: 2, name: "Jolly", cat_or_dog: "dog", breed: "Cocker-Spaniel", weight: "45", vaccinations: "true", spay_or_neutered: "true", special_instructions: "Likes to eat watermelon.")



reservation = Reservation.create!(kennel_id: 1, user_id: 2, customer_first_name: 'John', customer_last_name: 'Smith', customer_email: 'johnsmith@gmail.com', customer_phone: '4071231234', pet_ids: '[1,2]', run_ids: '[1]', check_in_date: '2016-12-12', check_out_date: '2016-12-13', total_price: 90.0, room_details: "[[\"The Large Room\", 90]]")
reservation.reservationID = 1
reservation.kennelID = 1
reservation.userID = 2
reservation.save!

AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')
