class Review < ActiveRecord::Base
  belongs_to :place
  belongs_to :user

  validates :body, :note, presence: true
  validates :note, numericality: { only_integer: true }
  validate :note_has_to_be_between_one_and_five

  after_destroy :update_rate
  after_save :update_rate

  private
  def note_has_to_be_between_one_and_five
    if note != nil and (note < 1 or note > 5)
      errors.add(:note, "Has to be between one and five")
    end
  end

  def update_rate
    self.place.update_rate
  end
end
