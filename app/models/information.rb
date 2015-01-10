# == Schema Information
#
# Table name: information
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  value      :text
#  created_at :datetime
#  updated_at :datetime
#

class Information < ActiveRecord::Base
  scope :popular_places, -> { where(name: 'popular_places')[0] }
end
