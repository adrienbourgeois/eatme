FactoryGirl.define do

  factory :photo do
    sequence(:instagram_id) { |n| n }
    image_low_resolution "image-test.png"
    image_standard_resolution "image-test.png"
    image_thumbnail "image-test.png"
    instagram_url "http://instagram.com"
    instagram_body_req "instagram_body_req"
    tags 'tag_example'
    checked true
    association :place
  end

  factory :place do
    sequence(:google_id) { |n| n }
    name "Adriatic"
    types "[\"restaurant\"]"
    vicinity "333 opera quay, Sydney"
    latitude '-33.0'
    longitude '180.0'
    city_code 1
    city_name 'Sydney'
  end

end

