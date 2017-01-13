class Pet < ActiveRecord::Base
  belongs_to :user

  validates :name, format: { with: /\A[a-z\s-]{3,30}\z/i }
  validates :cat_or_dog, presence: true
  validates_numericality_of :weight, only_integer: true
  validates :vaccinations, presence: true
  validates :spay_or_neutered, presence: true

  has_attached_file :vaccination_record
  validates_attachment :vaccination_record, content_type: { content_type: ["application/pdf", "application/msword"] }

  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/assets/default_photo_image.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/

end
