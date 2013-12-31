class Review < ActiveRecord::Base
  belongs_to :place
  belongs_to :user

  validates :body, :note, presence: true
  validates :note, numericality: { only_integer: true }

  before_destroy :unrate_place

  private

  def unrate_place
    place = Place.find(self.place_id)
    place.update_rate(self.note, -1)
  end
end
