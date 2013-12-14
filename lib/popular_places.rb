module PopularPlaces

  NUMBER_OF_POPULAR_PLACES = 20

  def update_popular_places
    popular_places_array = Place.all.sort { |x,y| y.photos.count <=> x.photos.count }[0...NUMBER_OF_POPULAR_PLACES]
    result = popular_places_array.map { |popular_place| popular_place.id }
    Information.popular_places.update_attribute(:value,result.to_s)
  end

end
