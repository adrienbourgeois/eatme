module InstagramListener

  MAX_EXECUTION_TIME = 3500
  ROUND_SLEEP_TIME = 10

  def in_sydney? lat, long
    long_a = 150.847092
    long_b = 151.338730
    lat_a = -34.047637
    lat_b = -33.727864
    long_a < long && long < long_b && lat_a < lat && lat < lat_b
  end

  def in_sf? lat, long
    long_a = -123.060608
    long_b = -121.201172
    lat_a = 37.569209
    lat_b = 38.229180
    long_a < long && long < long_b && lat_a < lat && lat < lat_b
  end

  def is_not_in_db? instagram_id
    Photo.find_by(instagram_id: instagram_id) == nil
  end

  def google_find place_name, latitude, longitude
    if File.exist?("#{Rails.root.to_s}/config/config.yml")
      api_credentials = YAML.load_file("#{Rails.root.to_s}/config/config.yml")
      @client = GooglePlaces::Client.new(api_credentials['google_api_key'])
    else
      @client = GooglePlaces::Client.new(ENV['google_api_key'])
    end
    spots = @client.spots(latitude, longitude, radius: 100,
                          types: ['restaurant','food','cafe','hotel','bar'],
                          name: place_name)
    if spots.count == 1
      spot = spots[0]
      google_id = spot.id[0..12].to_i(26)
      {
        vicinity: spot.vicinity,
        name: spot.name,
        types: spot.types.to_s,
        latitude: spot.lat,
        longitude: spot.lng,
        google_id: google_id
      }
    else
      nil
    end
  end

  def instagram_query
    results = Instagram.tag_recent_media('foodporn', { count: 100 })
    results += Instagram.tag_recent_media('fooddie', { count: 100 })
    results += Instagram.tag_recent_media('instafood', { count: 100 })
    results += Instagram.tag_recent_media('food', { count: 100 })
    results += Instagram.tag_recent_media('foodpic', { count: 100 })
    results += Instagram.tag_recent_media('foodstagram', { count: 100 })
    results += Instagram.tag_recent_media('foodgasm', { count: 100 })
    #dessert, restaurant, pancake, delicious, chicken, seafood, glutenfree, vegan, burger, pizza
  end

  def script
    start = Time.now
    count = 0
    while (Time.now - start).to_i < MAX_EXECUTION_TIME
      results = instagram_query
      puts "round##{count}"
      results.each do |result|
        if result[:location] && result[:location][:name] && result['type'] == "image"
          latitude = result['location']['latitude']
          longitude = result['location']['longitude']
          if in_sydney?(latitude, longitude)
            instagram_id = result['id'].split('_')[0].to_i
            if is_not_in_db? instagram_id
              place_name = result['location']['name']

              puts result[:link]
              puts place_name

              google_response = google_find place_name, latitude, longitude
              place_id = 0

              if google_response
                puts google_response
                place = Place.find_or_create_by(google_id: google_response[:google_id]) { |p| p.update_attributes(google_response) }
                place_id = place.id
              end

              photo_attr = {
                image_low_resolution: result['images']['low_resolution']['url'],
                image_thumbnail: result['images']['thumbnail']['url'],
                image_standard_resolution: result['images']['standard_resolution']['url'],
                instagram_url: result['link'],
                instagram_body_req: result.to_json,
                tags: result['tags'].to_s,
                instagram_id: instagram_id,
                place_id: place_id,
                checked: google_response ? true : false
              }
              Photo.create(photo_attr)
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

