class Run < ActiveRecord::Base
  has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/assets/default_photo_image.png"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

  belongs_to :kennel
  validates_numericality_of :price
  validates_numericality_of :size_width, only_integer: true
  validates_numericality_of :size_length, only_integer: true
  validates_numericality_of :number_of_rooms, only_integer: true
  validates_numericality_of :pets_per_run, format: { with: /\A[0-9]{1,2}\z/i }
  validates :type_of_pets_allowed, presence: true
  validates :title, format: { with: /\A[a-z\s-]{3,30}\z/i }
  validates :description, presence: true
  validates :indoor_or_outdoor, presence: true
end
