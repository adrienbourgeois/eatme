FactoryGirl.define do

  factory :photo do
    sequence(:instagram_id) { |n| n }
    image_low_resolution "/assets/image-test.jpg"
    image_standard_resolution "/assets/image-test.jpg"
    image_thumbnail "/assets/image-test.jpg"
    instagram_url "http://instagram.com"
    instagram_body_req "instagram_body_req"
    tags "[\"pizza\"]"
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

  factory :user do
    name 'George Henri'
  end

  factory :review do
    association :user
    association :place
    rate 3
    body 'awesome'
  end

end

