class Place < ActiveRecord::Base
  geocoded_by :latitude  => :latitude, :longitude => :longitude

  has_many :photos
  has_many :reviews
  validates :google_id,:name,:types,:vicinity,:latitude,:longitude,:city_code,:city_name, presence: true
  validates :google_id, numericality: { only_integer: true }
  validates :latitude, :longitude, numericality: true

  cattr_accessor :filter_keyword

  RADIUS = [0.1,0.3,0.6,1.0,1.5,2.0,3.0,5.0]

  def self.popular
    ids_array = JSON.parse(Information.find_by(name:'popular_places').value)
    places = self.find(ids_array)
    ids_array.map { |i| places.select { |p| p.id == i }[0] }
  end

  def self.close(latitude,longitude,radius,filter_keyword)
    raise ArgumentError, "The radius is not correct" unless RADIUS.map(&:to_s).include? radius
    raise ArgumentError, "The filter keyword is not correct" unless (Photo::FILTER_KEYWORDS+[""]).include? filter_keyword
    self.near([latitude,longitude], radius).joins(:photos).preload(:photos)
      .where("photos.tags like '%#{filter_keyword}%'").uniq(:id)
  end

  def update_rate_average
    self.reviews_count = self.reviews.count
    if self.reviews_count == 0
      self.rate_average = -1.0
    else
      self.rate_average = self.reviews.average(:rate).to_f
    end
    self.save
  end

  def photos_filtered
    self.photos.where("tags LIKE '%#{filter_keyword}%'")
  end
end
