class Place < ActiveRecord::Base
  geocoded_by :latitude  => :latitude, :longitude => :longitude

  has_many :photos
  has_many :reviews
  validates :google_id,:name,:types,:vicinity,:latitude,:longitude, presence: true
  validates :google_id, numericality: { only_integer: true }
  validates :latitude, :longitude, numericality: true

  RADIUS = [0.1,0.3,0.6,1.0,1.5,2.0,3.0,5.0]

  def self.popular
    ids_array = JSON.parse(Information.find_by(name:'popular_places').value)
    places = self.find(ids_array)
    ids_array.map { |i| places.select { |p| p.id == i }[0] }
  end

  def self.close(latitude,longitude,radius)
    raise ArgumentError, "The radius is not correct" unless RADIUS.map(&:to_s).include? radius
    self.near([latitude,longitude], radius)
  end

  def update_rate
    self.number_of_reviews = self.reviews.count
    if self.number_of_reviews == 0
      self.rate = -1.0
    else
      self.rate = self.reviews.average(:note).to_f
    end
    self.save
  end

end
