module InstagramListener

  MAX_EXECUTION_TIME = 3500
  ROUND_SLEEP_TIME = 10

  def in_city? lat, long, city_area
    city_area[0] < long && long < city_area[1] && city_area[2] < lat && lat < city_area[3]
  end

  def city_hash lat, long
    CITIES.each { |city| return city if in_city?(lat, long, city) }
    return false
  end

  def is_not_in_db? instagram_id
    Photo.find_by(instagram_id: instagram_id) == nil
  end

  def google_find place_name, latitude, longitude
    spots = Client_google.spots(latitude, longitude, radius: 100,
                                types: ['restaurant','food','cafe','hotel','bar'],
                                name: place_name)
    if spots.count == 1
      spot = spots[0]
      city = city_hash latitude, longitude
      google_id = spot.id[0..12].to_i(26)
      {
        vicinity: spot.vicinity,
        name: spot.name,
        types: spot.types.to_s,
        latitude: spot.lat,
        longitude: spot.lng,
        google_id: google_id,
        city_code: city[:code],
        city_name: city[:name]
      }
    else
      nil
    end
  end

  def instagram_query
    places = []
    begin
      TAGS.each { |ht| places += Instagram.tag_recent_media(ht, { count: 100 })}
    rescue
      places = nil
    end
    return places
  end

  def photo_attr place, instagram_id, place_id, checked
    {
      image_low_resolution: place['images']['low_resolution']['url'],
      image_thumbnail: place['images']['thumbnail']['url'],
      image_standard_resolution: place['images']['standard_resolution']['url'],
      instagram_url: place['link'],
      instagram_body_req: place.to_json,
      tags: place['tags'].to_s,
      instagram_id: instagram_id,
      place_id: place_id,
      checked: checked
    }
  end

  def google_places_match place_instagram, latitude, longitude, instagram_id
    place_name = place_instagram['location']['name']

    puts place_instagram[:link]
    puts place_name

    google_response = google_find place_name, latitude, longitude
    place_id = 0

    if google_response
      puts google_response
      place = Place.find_or_create_by(google_id: google_response[:google_id]) { |p| p.update_attributes(google_response) }
      place_id = place.id
    end

    Photo.create(photo_attr(place_instagram, instagram_id, place_id, google_response ? true : false))
  end

  def script
    start = Time.now
    count = 0
    while (Time.now - start).to_i < MAX_EXECUTION_TIME
      places = instagram_query
      puts "round##{count}"
      places.each do |place|
        if place[:location] && place[:location][:name] && place['type'] == "image"
          latitude = place['location']['latitude']
          longitude = place['location']['longitude']
          if city_hash(latitude, longitude)
            instagram_id = place['id'].split('_')[0].to_i
            if is_not_in_db? instagram_id
              google_places_match place, latitude, longitude, instagram_id
            end
            puts "id: #{count}"
          end
        end
        count += 1
      end
      puts "chrono: #{(Time.now-start).to_i/1.minute} min"
      sleep ROUND_SLEEP_TIME
    end
  end
end

