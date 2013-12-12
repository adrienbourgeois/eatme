require 'pry'

class Place < ActiveRecord::Base
  geocoded_by :latitude  => :latitude, :longitude => :longitude

  has_many :photos
  validates :google_id,:name,:types,:vicinity,:latitude,:longitude, presence: true
  validates :google_id, numericality: { only_integer: true }
  validates :latitude, :longitude, numericality: true

  RAYON = [0.1,0.3,0.6,1.0,1.5,2.0,3.0,5.0]

  def self.popular
    ids_array = JSON.parse(Information.find_by(name:'popular_places').value)
    places = self.find(ids_array)
    ids_array.map { |i| places.select { |p| p.id == i }[0] }
  end

  def self.close(latitude,longitude,rayon,page,per_page)
    raise ArgumentError, "The rayon is not correct" unless RAYON.include? rayon.to_f
    self.near([latitude,longitude], rayon).page(page).per(per_page)
  end

end
