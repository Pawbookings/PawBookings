class User < ActiveRecord::Base
  has_one  :kennel
  has_one  :customer_vet_info
  has_one  :customer_emergency_contact
  has_many :visits
  has_many :photos
  has_many :pets
  has_many :reservations
  has_many :kennels, through: :reservations
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone,:presence => true,
                 :numericality => true,
                 :length => { :minimum => 10, :maximum => 15 }

  has_attached_file :user_image,
               :storage => :s3,
               styles: { small: "350x333#" }, default_url: "/assets/default_photo_image.png",
               :s3_permissions => { :original => :private, :export => {:quality => 100} },
               :convert_options => { :all => "-quality 100" },
               url: ":s3_domain_url",
               path: "/image/:id/:filename",
               s3_region: 'ENV["aws_region"]',
               s3_protocol: :https,
               :s3_credentials => Proc.new{|a| a.instance.s3_credentials }

  def s3_credentials
    {:bucket => ENV["aws_bucket"], :access_key_id => ENV["aws_access_key_id"], :secret_access_key => ENV["aws_secret_access_key"]}
  end
  validates_attachment_content_type :user_image, content_type: /\Aimage\/.*\Z/
  validates_attachment_size :user_image, less_than: 3.megabytes
end
