class Pet < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :cat_or_dog, presence: true
  validates_numericality_of :weight, only_integer: true
  validates :vaccinations, presence: true
  validates :spay_or_neutered, presence: true

  has_attached_file :vaccination_record,
                    :storage => :s3,
                    :s3_permissions => { :original => :private },
                    url: ":s3_domain_url",
                    path: "/files/:id/:filename",
                    s3_region: ENV["aws_region"],
                    :s3_credentials => Proc.new{|a| a.instance.s3_credentials }
  validates_attachment :vaccination_record, content_type: { content_type: ["application/pdf", "application/msword"] }

  has_attached_file :avatar,
                    :storage => :s3,
                    styles: { small: "350x333#" }, default_url: "/assets/default_photo_image.png",
                    :s3_permissions => { :original => :private, :export => {:quality => 100} },
                    :convert_options => { :all => "-quality 100" },
                    url: ":s3_domain_url",
                    path: "/image/:id/:filename",
                    s3_region: ENV["aws_region"],
                    :s3_credentials => Proc.new{|a| a.instance.s3_credentials }
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/

  def s3_credentials
   {:bucket => ENV["aws_bucket"], :access_key_id => ENV["aws_access_key_id"], :secret_access_key => ENV["aws_secret_access_key"]}
  end
end
