module PopularPlaces

  NUMBER_OF_POPULAR_PLACES = 20

  def update_popular_places
    popular_places_array = Place.all.sort { |x,y| compare_place_popularity(x,y) }[0..NUMBER_OF_POPULAR_PLACES-1]
    result = []
    popular_places_array.each { |popular_place| result += [popular_place.id] }
    popular_places_db = Information.find_by(name:'popular_places')
    popular_places_db = Information.create(name:'popular_places') unless popular_places_db
    popular_places_db.update_attribute(:value,result.to_s)
  end

  private

  def compare_place_popularity place1, place2
    place1_photos_count = place1.photos.count
    place2_photos_count = place2.photos.count
    return 1 if place1_photos_count < place2_photos_count
    return 0 if place1_photos_count == place2_photos_count
    return -1 if place1_photos_count > place2_photos_count
  end
end
