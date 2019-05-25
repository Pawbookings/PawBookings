class Run < ActiveRecord::Base

  has_attached_file :image,
                :storage => :s3,
                styles: { small: "300x333#" }, default_url: "/assets/default_photo_image.png",
                :s3_permissions => { :original => :private, :export => {:quality => 100} },
                :convert_options => { :all => "-quality 100" },
                url: ":s3_domain_url",
                path: "/image/:id/:filename",
                s3_region: "ENV['aws_region']",
                s3_protocol: :https,
                default_url: "/images/:style/missing.png",
                :s3_credentials => Proc.new{|a| a.instance.s3_credentials }

  def s3_credentials
    {:bucket => ENV["aws_bucket"], :access_key_id => ENV["aws_access_key_id"], :secret_access_key => ENV["aws_secret_access_key"]}
    end

  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
  validates_attachment_size :image, less_than: 3.megabytes

  belongs_to :kennel
  validates_numericality_of :price
  validates_numericality_of :size_width, only_integer: true
  validates_numericality_of :size_length, only_integer: true
  validates_numericality_of :number_of_rooms, only_integer: true
  validates_numericality_of :pets_per_run, format: { with: /\A[0-9]{1,2}\z/i }
  validates :type_of_pets_allowed, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates :indoor_or_outdoor, presence: true
end
