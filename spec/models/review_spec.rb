# == Schema Information
#
# Table name: reviews
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  place_id   :integer
#  rate       :integer
#  body       :text
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Review do
end
