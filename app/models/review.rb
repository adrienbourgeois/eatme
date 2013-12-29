class Review < ActiveRecord::Base
  belongs_to :place
  belongs_to :user

  validates :body, :note, presence: true
  validates :note, numericality: { only_integer: true }
end
