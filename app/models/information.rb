class Information < ActiveRecord::Base
  scope :popular_places, -> { where(name: 'popular_places')[0] }
end
