class Kennel < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  def should_generate_new_friendly_id?
    name_changed?
  end

  belongs_to :user
  has_one    :kennel_check_in_check_out
  has_one    :hours_of_operation
  has_many   :breed_restrictions
  has_many   :holidays
  has_many   :runs
  has_many   :amenities
  has_many   :policies
  has_many   :photos
  has_many   :reservations
  has_many   :stand_by_reservations
  has_many   :users, through: :reservations

  # validates :name, presence: true
  # validates :address, length: { minimum: 3 }
  # validates :mission_statement, presence: true
  # validates :city, presence: true
  # validates :state, presence: true
  # validates :zip, format: { with: /\A[0-9]{5}\z/i }
  # validates :phone, format: { with: /\A\+?[0-9]{,2}(-|\s)?\(?[0-9]{3}\)?(-|\s)?[0-9]{3}(-|\s)?[0-9]{4}\z/ }
  # validates :email, uniqueness: true
  # validates :cats_or_dogs, presence: true

  geocoded_by :zip
  after_validation :geocode, if: ->(obj){ obj.zip.present? and obj.zip_changed? }

  has_attached_file :avatar,
                :storage => :s3,
                styles: { small: "350x333#" }, default_url: "/assets/default_photo_image.png",
                :s3_permissions => { :original => :private, :export => {:quality => 100} },
                :convert_options => { :all => "-quality 100" },
                url: ":s3_domain_url",
                path: "/image/:id/:filename",
                s3_region: ENV["aws_region"],
                :s3_credentials => Proc.new{|a| a.instance.s3_credentials }

  def s3_credentials
    {:bucket => ENV["aws_bucket"], :access_key_id => ENV["aws_access_key_id"], :secret_access_key => ENV["aws_secret_access_key"]}
  end

  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

end
