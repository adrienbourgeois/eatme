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

class Review < ActiveRecord::Base
  belongs_to :place
  belongs_to :user

  validates :body, :rate, presence: true
  validates :rate, numericality: { only_integer: true }
  validate :rate_has_to_be_between_one_and_five

  after_destroy :update_rate_average
  after_save :update_rate_average

  private
  def rate_has_to_be_between_one_and_five
    if rate != nil and (rate < 1 or rate > 5)
      errors.add(:rate, "Has to be between one and five")
    end
  end

  def update_rate_average
    self.place.update_rate_average
  end
end
