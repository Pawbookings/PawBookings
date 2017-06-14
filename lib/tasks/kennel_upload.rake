require 'csv'
require 'devise'

task :upload_kennel_csv => :environment do
  csv_text = File.read(Rails.root.join('lib', 'seeds', 'kennel.csv'))
  csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
  counter = 0
  csv.each do |row|
    if !row['zip'].blank?
      # Create User
      u = User.new
      if row['website_email'].blank?
        u.email = "business_#{counter}@tempmail.com"
      else
        if row['website_email'].include? "@"
          u.email = row['website_email']
        else
          u.email = "business_#{counter}@tempmail.com"
        end
      end
      u.password = SecureRandom.hex(12)
      u.password_confirmation = u.password
      u.kennel_or_customer = "kennel"
      u.phone = row['phone'].blank? ? '0000000000' : row['phone'].tr("()", "").tr(" ", "")
      u.save!

      # Create Kennel
      k = Kennel.new
      k.user_id = u.id
      k.taken_ownership = false
      k.name = row['company_name']
      k.address = row['address']
      k.city = row['city']
      k.state = row['state']
      k.zip = row['zip'].include?('-') ? row['zip'].split('-').first : row['zip']
      k.sales_tax = 0.0
      k.mission_statement = "Fill in with mission statement"
      k.phone = "0000000000"
      k.email = "customer_contact@yourbusiness.com"
      k.cats_or_dogs = "both"
      k.save!
      k.kennelID = k.id
      k.userID = u.id
      k.save!
      counter += 1
    end
  end
end
