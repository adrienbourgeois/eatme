# == Schema Information
#
# Table name: photos
#
#  id                        :integer          not null, primary key
#  instagram_id              :integer
#  image_low_resolution      :string(255)
#  image_thumbnail           :string(255)
#  image_standard_resolution :string(255)
#  instagram_url             :string(255)
#  instagram_body_req        :text
#  tags                      :string(255)
#  created_at                :datetime
#  updated_at                :datetime
#  checked                   :boolean          default("f")
#  place_id                  :integer
#


class Photo < ActiveRecord::Base
  belongs_to :place
  validates :instagram_id,:image_low_resolution,:image_thumbnail,:tags, presence: true
  validates :image_standard_resolution,:instagram_url,:instagram_body_req, presence: true
  validates :instagram_id, numericality: { only_integer: true }
  validates :checked, inclusion: { in: [true,false], message: "has to be true or false" }

  scope :checked, -> { where(checked: true) }

  FILTER_KEYWORDS = [
    'glutenfree',
    'dessert',
    'bbq',
    'ribs',
    'healthy',
    'pizza',
    'veg',
    'chinese',
    'thai',
    'italian',
    'sea',
    'pancake',
    'icecream',
    'french'
  ]

end
