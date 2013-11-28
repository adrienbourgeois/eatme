module InstagramListener

  MAX_EXECUTION_TIME = 3500
  ROUND_SLEEP_TIME = 10


  def update_instagram_id
    Photo.all.each do |photo|
      photo_info = JSON.parse photo.instagram_body_req
      new_id = photo_info['id'].split("_")[0].to_i
      photo.update_attribute(:instagram_id, new_id)
    end
  end

  def destroy_doublon
    Photo.all.each do |photo|
      instagram_id = photo.instagram_id
      Photo.all.where(instagram_id: instagram_id)[1..-1].each do |photo_b|
        photo_b.destroy
      end
    end
  end


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

  API_KEY = 'AIzaSyBoOYKjtORixe_wELz_I5bK97AwR9yz2TM'
  @client = GooglePlaces::Client.new(API_KEY)


  def google_find place_name, latitude, longitude
    #if File.exist?("#{Rails.root.to_s}/config/config.yml")
      #API_CREDENTIALS = YAML.load_file("#{Rails.root.to_s}/config/config.yml")
      #puts "================== #{API_CREDENTIALS['google_api_key']}"
      #@client = GooglePlaces::Client.new(API_CREDENTIALS['google_api_key'])
    #end
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

  def find_places
    Photo.all.each do |photo|

      instagram_body_req = JSON.parse photo['instagram_body_req']
      latitude = instagram_body_req['location']['latitude']
      longitude = instagram_body_req['location']['longitude']
      place_name = instagram_body_req['location']['name']

      google_response = google_find place_name, latitude, longitude
      puts google_response
      if google_response
        place = Place.find_by(google_id: google_response[:google_id])
        if !place
          Place.create(google_response)
        end
      end

    end
  end

  def update_photo_place
    Photo.all.each do |photo|
      instagram_body_req = JSON.parse photo['instagram_body_req']
      latitude = instagram_body_req['location']['latitude']
      longitude = instagram_body_req['location']['longitude']
      place_name = instagram_body_req['location']['name']


      google_response = google_find place_name, latitude, longitude
      puts google_response
      if google_response
        place = Place.find_by(google_id: google_response[:google_id])
        if !place
          puts "========Problem!!"
        else
          photo.update_attribute(:checked, true)
          photo.update_attribute(:place_id, place.id)
        end
      end
    end
  end

  def script

    start = Time.now

    #Instagram.configure do |config|
    #config.client_id = "c35bc560cef94c148dcf2c48cdc4c31d"
    #config.client_secret = "9e951e5f4983466f855d14e1af5fc2fe"
    #end

    puts in_sydney?(-33.863687, 151.209083)

    count = 0
    while (Time.now - start).to_i < MAX_EXECUTION_TIME

      results = Instagram.tag_recent_media('foodporn', { count: 100 })
      results += Instagram.tag_recent_media('fooddie', { count: 100 })
      results += Instagram.tag_recent_media('instafood', { count: 100 })
      results += Instagram.tag_recent_media('food', { count: 100 })
      results += Instagram.tag_recent_media('foodpic', { count: 100 })
      results += Instagram.tag_recent_media('foodstagram', { count: 100 })
      results += Instagram.tag_recent_media('foodgasm', { count: 100 })
      #dessert, restaurant, pancake, delicious, chicken, seafood, glutenfree, vegan, burger, pizza

      puts "round##{count}"
      results.each do |result|
        if result[:location] && result[:location][:name] && result['type'] == "image"
          latitude = result['location']['latitude']
          longitude = result['location']['longitude']
          if in_sydney?(latitude, longitude)
            instagram_id = result['id'].split('_')[0].to_i

            if is_not_in_db? instagram_id
              place_name = result['location']['name']
              image_low_resolution = result['images']['low_resolution']['url']
              image_thumbnail = result['images']['thumbnail']['url']
              image_standard_resolution = result['images']['standard_resolution']['url']
              instagram_url = result['link']
              instagram_body_req = result.to_json
              tags = result['tags'].to_s

              puts result[:link]
              puts place_name

              google_response = google_find place_name, latitude, longitude
              checked = google_response ? true : false
              place_id = 0

              if google_response
                puts google_response
                place = Place.find_by(google_id: google_response[:google_id])
                place = Place.create(google_response) unless place
                place_id = place.id
              end



              Photo.create(
                instagram_id: instagram_id,
                image_low_resolution: image_low_resolution,
                image_thumbnail: image_thumbnail,
                image_standard_resolution: image_standard_resolution,
                instagram_url: instagram_url,
                instagram_body_req: instagram_body_req,
                tags: tags,
                place_id: place_id,
                checked: checked
              )
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
#include InstagramListener


#InstagramListener.script

#puts InstagramService.is_not_in_db? 590936166465201281
#puts InstagramService.is_not_in_db? 590937478780558384
#puts InstagramService.is_not_in_db? 590944518769053839
#puts InstagramService.is_not_in_db? 590842480352989972
#puts InstagramService.is_not_in_db? 590736442735554727

#InstagramService.update_instagram_id

#InstagramService.destroy_doublon


#InstagramService.find_places
#InstagramService.update_photo_place
