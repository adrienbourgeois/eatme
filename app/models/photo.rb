
class Photo < ActiveRecord::Base
  belongs_to :place
  validates :instagram_id,:image_low_resolution,:image_thumbnail,:tags, presence: true
  validates :image_standard_resolution,:instagram_url,:instagram_body_req, presence: true
  validates :instagram_id, numericality: { only_integer: true }
  validates :checked, inclusion: { in: [true,false], message: "has to be true or false" }

  scope :checked, -> { where(checked: true) }

end
