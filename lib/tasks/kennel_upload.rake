require 'csv'
require 'devise'

task :upload_kennel_csv => :environment do
  csv_text = File.read(Rails.root.join('lib', 'seeds', 'kennel.csv'))
  csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
  if Kennel.last.nil?
    counter = 1
  else
    counter = Kennel.last.id + 1
  end
  limit_reached = false
  csv.each do |row|
    break if limit_reached == true
    if !row['zip'].blank?
      sleep(1)
      # Create User
      u = User.new
      if row['email'].blank?
        u.email = "business_#{counter}@tempmail.com"
      else
        u.email = row['email']
      end
      next if !User.where(email: u.email).last.nil?
      u.password = SecureRandom.hex(12)
      u.password_confirmation = u.password
      u.kennel_or_customer = "kennel"
      u.phone = row['phone'].blank? ? '0000000000' : row['phone'].tr("()", "").tr(" ", "")
      u.save!

      # Create Kennel
      row['zip'].prepend("0") if row['zip'].length == 4
      k = Kennel.new
      k.user_id = u.id
      k.taken_ownership = false
      k.name = row['company_name']
      k.address = row['address']
      k.city = row['city']
      k.state = row['state']
      k.zip = row['zip'].include?('-') ? row['zip'].split('-').first : row['zip']
      k.sales_tax = 0.0
      k.mission_statement = "PawBookings Sponsored Kennel"
      k.phone = "0000000000"
      k.email = "customer_contact_#{counter}@yourbusiness.com"
      k.cats_or_dogs = "both"
      k.save!
      counter += 1
      if k.latitude.nil?
        limit_reached = true
        k.delete
      end
    end # if !row['zip'].blank?
  end # csv.each do |row|
end # task :upload_kennel_csv => :environment do
