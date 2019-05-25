class Ckeditor::Picture < Ckeditor::Asset
  has_attached_file :data,
  :storage => :s3,
  styles: { content: '500x350#', thumb: '500x350#' },
  :s3_permissions => { :original => :private, :export => {:quality => 100} },
  :convert_options => { :all => "-quality 100" },
  url: ":s3_domain_url",
  path: "/image/:id/:filename",
  s3_region: "ENV["aws_region"]",
  s3_protocol: :https,
  default_url: "/images/:style/missing.png",
  :s3_credentials => Proc.new{|a| a.instance.s3_credentials }

  def s3_credentials
    {:bucket => ENV["aws_bucket"], :access_key_id => ENV["aws_access_key_id"], :secret_access_key => ENV["aws_secret_access_key"]}
  end

  validates_attachment_presence :data
  validates_attachment_size :data, less_than: 2.megabytes
  validates_attachment_content_type :data, content_type: /\Aimage/

  def url_content
    url(:content)
  end
end
