class InstagramService

  def self.update_instagram_id
    Photo.all.each do |photo|
      photo_info = JSON.parse photo.instagram_body_req
      new_id = photo_info['id'].split("_")[0].to_i
      photo.update_attribute(:instagram_id, new_id)
    end
  end

  def self.destroy_doublon
    Photo.all.each do |photo|
      instagram_id = photo.instagram_id
      Photo.all.where(instagram_id: instagram_id)[1..-1].each do |photo_b|
        photo_b.destroy
      end
    end
  end


  def self.in_sydney? lat, long
    long_a = 150.847092
    long_b = 151.338730
    lat_a = -34.047637
    lat_b = -33.727864
    long_a < long && long < long_b && lat_a < lat && lat < lat_b
  end

  def self.in_sf? lat, long
    long_a = -123.060608
    long_b = -121.201172
    lat_a = 37.569209
    lat_b = 38.229180
    long_a < long && long < long_b && lat_a < lat && lat < lat_b
  end

  def self.is_not_in_db? instagram_id
    Photo.find_by(instagram_id: instagram_id) == nil
  end

  def self.google_find place_name, latitude, longitude
    spots = @client.spots(latitude, longitude, radius: 100,
                          types: ['restaurant','food','cafe','hotel'],
                          name: place_name)

    spots.each do |spot|
      return spot.vicinity if spot.name.capitalize == place_name.capitalize
    end
    return nil
  end

  API_KEY = 'AIzaSyBoOYKjtORixe_wELz_I5bK97AwR9yz2TM'
  def self.script
    Instagram.configure do |config|
      config.client_id = "c35bc560cef94c148dcf2c48cdc4c31d"
      config.client_secret = "9e951e5f4983466f855d14e1af5fc2fe"
    end

    @client = GooglePlaces::Client.new(API_KEY)

    puts in_sydney?(-33.863687, 151.209083)

    count = 0
    while true

      results = Instagram.tag_recent_media('foodporn', { count: 100 })
      results += Instagram.tag_recent_media('fooddie', { count: 100 })
      results += Instagram.tag_recent_media('instafood', { count: 100 })
      results += Instagram.tag_recent_media('food', { count: 100 })
      results += Instagram.tag_recent_media('foodpic', { count: 100 })

      puts "round##{count}"
      results.each do |result|
        if result[:location] && result[:location][:name] && result['type'] == "image"
          latitude = result['location']['latitude']
          longitude = result['location']['longitude']
          if in_sydney?(latitude, longitude)
            instagram_id = result['id'].split('_')[0].to_i

            if is_not_in_db? instagram_id
              place_name = result['location']['name']
              address = google_find place_name, latitude, longitude
              #if address
              image_low_resolution = result['images']['low_resolution']['url']
              image_thumbnail = result['images']['thumbnail']['url']
              image_standard_resolution = result['images']['standard_resolution']['url']
              instagram_url = result['link']
              instagram_body_req = result.to_json
              tags = result['tags'].to_s
              puts result[:link]
              puts place_name
              puts address

              Photo.create( latitude: latitude,
                           longitude: longitude,
                           place_name: place_name,
                           address: address,
                           instagram_id: instagram_id,
                           image_low_resolution: image_low_resolution,
                           image_thumbnail: image_thumbnail,
                           image_standard_resolution: image_standard_resolution,
                           instagram_url: instagram_url,
                           instagram_body_req: instagram_body_req,
                           tags: tags
                          )
            end

            puts "id: #{count}"
            #end
          end
        end
        count += 1
      end
      sleep 30
    end
  end

end

#InstagramService.script

#puts InstagramService.is_not_in_db? 590936166465201281
#puts InstagramService.is_not_in_db? 590937478780558384
#puts InstagramService.is_not_in_db? 590944518769053839
#puts InstagramService.is_not_in_db? 590842480352989972
#puts InstagramService.is_not_in_db? 590736442735554727

#InstagramService.update_instagram_id

InstagramService.destroy_doublon
