class Blog < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders]

  def should_generate_new_friendly_id?
    title_changed?
  end

  has_attached_file :blog_display_image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/assets/default_testimonial_image.jpg"
  validates_attachment_content_type :blog_display_image, content_type: /\Aimage\/.*\Z/
end
