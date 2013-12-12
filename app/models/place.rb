require 'pry'

class Place < ActiveRecord::Base
  has_many :photos
  validates :google_id,:name,:types,:vicinity,:latitude,:longitude, presence: true
  validates :google_id, numericality: { only_integer: true }
  validates :latitude, :longitude, numericality: true

  geocoded_by :latitude  => :latitude, :longitude => :longitude
  PER_PAGE = 1

  def self.popular
    ids_array = JSON.parse(Information.find_by(name:'popular_places').value)
    places = Place.find(ids_array)
    ids_array.map { |i| places.select { |p| p.id == i }[0] }
  end

  def self.close_places(latitude,longitude,rayon,page)
    Place.near([latitude,longitude], rayon).page(page).per(PER_PAGE)
  end

end
