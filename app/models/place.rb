class Place < ActiveRecord::Base
  has_many :photos
  geocoded_by :latitude  => :latitude, :longitude => :longitude

  def self.popular_places
    popular_places_array = []
    JSON.parse(Information.find_by(name:'popular_places').value).each do |id|
      popular_places_array += [Place.find(id)]
    end
    popular_places_array
  end

end
