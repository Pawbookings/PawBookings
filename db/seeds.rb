# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# User
# 1 -Kennel
user = User.create!(first_name: "christopher", last_name: "pelnar", email: 'christopherpelnar@gmail.com', password: 'helloworld', password_confirmation: 'helloworld', phone: '4074081234', time_zone: 'Eastern Time (US & Canada)', kennel_or_customer: 'kennel')
user.userID = user[:id]
user.save!

# 2 -Customer
user = User.create!(first_name: "john", last_name: "smith", email: 'jsmith@gmail.com', password: 'helloworld', password_confirmation: 'helloworld', phone: '4078464231', time_zone: 'Eastern Time (US & Canada)', kennel_or_customer: 'customer')
user.userID = user[:id]
user.save!

# 3 -Customer
user = User.create!(first_name: "luke", last_name: "skywalker", email: 'lskywalker@gmail.com', password: 'helloworld', password_confirmation: 'helloworld', phone: '4071231234', time_zone: 'Eastern Time (US & Canada)', kennel_or_customer: 'customer')
user.userID = user[:id]
user.save!

# 4 -Customer
user = User.create!(first_name: "jim", last_name: "johnson", email: 'jjohnson@gmail.com', password: 'helloworld', password_confirmation: 'helloworld', phone: '4073214321', time_zone: 'Eastern Time (US & Canada)', kennel_or_customer: 'customer')
user.userID = user[:id]
user.save!

# 5 -Kennel
user = User.create!(first_name: "tony", last_name: "montana", email: 'tmontana@gmail.com', password: 'helloworld', password_confirmation: 'helloworld', phone: '3059569404', time_zone: 'Eastern Time (US & Canada)', kennel_or_customer: 'kennel')
user.userID = user[:id]
user.save!

#6 -Kennel
user = User.create!(first_name: "han", last_name: "solo", email: 'hsolo@gmail.com', password: 'helloworld', password_confirmation: 'helloworld', phone: '3212436990', time_zone: 'Eastern Time (US & Canada)', kennel_or_customer: 'kennel')
user.userID = user[:id]
user.save!

#7 -Customer
user = User.create!(first_name: "mary", last_name: "blossom", email: 'mblossom@gmail.com', password: 'helloworld', password_confirmation: 'helloworld', phone: '3218889978', time_zone: 'Eastern Time (US & Canada)', kennel_or_customer: 'customer')
user.userID = user[:id]
user.save!


# Kennel
kennel = Kennel.create!(user_id: 1, name: 'Kennel One', zip: '34741', address: '123 Fake St', city: 'Kissimme', state: 'FL', cats_or_dogs: "both", mission_statement: "On the other hand, we denounce with righteous indignation and dislike men who are so beguiled and demoralized by the charms of pleasure of the moment, so blinded by desire, that they cannot foresee the pain and trouble that are bound to ensue; and equal blame belongs to those who fail in their duty through weakness of will, which is the same as saying through shrinking from toil and pain. These cases are perfectly simple and easy to distinguish. In a free hour, when our power of choice is untrammelled and when nothing prevents our being able to do what we like best, every pleasure is to be welcomed and every pain avoided. But in certain circumstances and owing to the claims of duty or the obligations of business it will frequently occur that pleasures have to be repudiated and annoyances accepted. The wise man therefore always holds in these matters to this principle of selection: he rejects pleasures to secure other greater pleasures, or else he endures pains to avoid worse pains.", email: "kennel_one@gmail.com", phone: "4079331234", sales_tax: 6.9)
kennel.kennelID = kennel[:id]
kennel.userID = kennel[:user_id]
kennel.save!

# Hours Of Operation for Kennel.id => 1
HoursOfOperation.create!(kennel_id: 1, monday_open: "closed", monday_close: "closed", tuesday_open: "closed", tuesday_close: "closed", wednesday_open: "closed", wednesday_close: "closed", thursday_open: "closed", thursday_close: "closed", friday_open: "closed", friday_close: "closed", saturday_open: "closed", saturday_close: "closed", sunday_open: "closed", sunday_close: "closed")

# Run
Run.create!(kennel_id: 1, size_width: '12', size_length: '12', title: 'The Large Room', description: 'The largest room we have', indoor_or_outdoor: 'indoor', pets_per_run: 2, price: 90.0, weight_limit: 120, number_of_rooms: 2, type_of_pets_allowed: 'dog' )


# Admin
user = User.create!(first_name: "patrick", last_name: "mcdonnel", email: 'pawbookings@gmail.com', password: 'helloworld', password_confirmation: 'helloworld', phone: '4078464231', time_zone: 'Eastern Time (US & Canada)', kennel_or_customer: 'admin')
user.userID = user[:id]
user.save!


# Pet
# 1,2
Pet.create!(user_id: 2, name: "Petey", cat_or_dog: "dog", breed: "Pitbull", weight: "120", vaccinations: "true", spay_or_neutered: "true", special_instructions: "Likes to have belly scratched.")
Pet.create!(user_id: 2, name: "Jolly", cat_or_dog: "dog", breed: "Cocker-Spaniel", weight: "45", vaccinations: "true", spay_or_neutered: "true", special_instructions: "Likes to eat watermelon.")

# 3
Pet.create!(user_id: 3, name: "Chewy", cat_or_dog: "dog", breed: "German-Shepherd", weight: "145", vaccinations: "true", spay_or_neutered: "true", special_instructions: "Wets the bed")

# 4
Pet.create!(user_id: 4, name: "Rocky", cat_or_dog: "dog", breed: "Poodle", weight: "20", vaccinations: "true", spay_or_neutered: "true", special_instructions: "false")

# Amenity
# 1
Amenity.create!(kennel_id: 1, title: "Doggy Ice-Cream", description: "A smooth peanut butter taste with large chunks of tuna.", price: 4.99)
# 2
Amenity.create!(kennel_id: 1, title: "Doggy Day-SPA", description: "A relaxing time in our spa where your pet can come and be pampered.", price: 30.00)


# 1
reservation = Reservation.create!(kennel_id: 1, user_id: 2, customer_first_name: 'john', customer_last_name: 'smith', customer_email: 'jsmith@gmail.com', customer_phone: '4074081234', pet_ids: '[1,2]', run_ids: '[1]', check_in_date: '2016-12-12', check_out_date: '2016-12-13', total_price: 96.21, room_details: "[[\"The Large Room\", 90]]", completed: "false", transID: "87345876987965786")
reservation.reservationID = 1
reservation.kennelID = 1
reservation.userID = 2
reservation.save!

# 2
reservation = Reservation.create!(kennel_id: 1, user_id: 3, customer_first_name: 'luke', customer_last_name: 'skywalker', customer_email: 'lskywalker@gmail.com', customer_phone: '4071231234', pet_ids: '[3]', run_ids: '[1]', check_in_date: '2016-12-01', check_out_date: '2016-12-02', total_price: 96.21, room_details: "[[\"The Large Room\", 90]]", completed: "false", transID: "7709703987176987")
reservation.reservationID = 2
reservation.kennelID = 1
reservation.userID = 3
reservation.save!

# 3
reservation = Reservation.create!(kennel_id: 1, user_id: 4, customer_first_name: 'mary', customer_last_name: 'blossom', customer_email: 'mblossom@gmail.com', customer_phone: '4073214321', pet_ids: '[4]', run_ids: '[1]', check_in_date: '2016-12-10', check_out_date: '2016-12-11', total_price: 96.21, room_details: "[[\"The Large Room\", 90]]", completed: "false", transID: "09809796784876834")
reservation.reservationID = 3
reservation.kennelID = 1
reservation.userID = 4
reservation.save!

AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')

CheckInContractImportantInformation.create!(title: "Important Information", body: "This is to be edited by Admin.")
CheckInContractReservationChange.create!(title: "Important Information", body: "This is to be edited by Admin.")
CheckInContractRefundPolicy.create!(title: "Important Information", body: "This is to be edited by Admin.")

KennelRating.create!(reservation_id: 1, reservationID: 1, kennelID: 1, userID: 2, rating: 5, comment: "This is the best thing ever!")
KennelRating.create!(reservation_id: 2, reservationID: 2, kennelID: 1, userID: 3, rating: 5, comment: "I really love this place and couldn't imagine leaving Brüno anywhere else!")
KennelRating.create!(reservation_id: 3, reservationID: 3, kennelID: 1, userID: 4, rating: 5, comment: "My favorite kennel in the world!")
