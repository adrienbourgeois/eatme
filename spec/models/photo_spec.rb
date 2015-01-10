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

require 'spec_helper'

describe Photo do

end
