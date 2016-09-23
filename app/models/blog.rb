class Blog < ActiveRecord::Base
  has_attached_file :blog_display_image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/assets/default_testimonial_image.jpg"
  validates_attachment_content_type :blog_display_image, content_type: /\Aimage\/.*\Z/
end
