FactoryGirl.define do

  factory :photo1, class: Photo do
    instagram_id 1
    image_low_resolution "http://distilleryimage7.s3.amazonaws.com/0bf596885e0b11e38bf00abf480766b1_6.jpg"
    tags "[\"foodporn\"]"
    checked true
    place_id 1
  end

  factory :photo2, class: Photo do
    instagram_id 2
    image_low_resolution "http://distilleryimage7.s3.amazonaws.com/f54480785e2511e3989e1244f4c5d15f_6.jpg"
    tags "[\"foodporn\"]"
    checked true
    place_id 1
  end

  factory :photo3, class: Photo do
    instagram_id 3
    image_low_resolution "http://distilleryimage0.s3.amazonaws.com/d00cd95e5e2511e3b7b51237f4328294_6.jpg"
    tags "[\"foodporn\"]"
    checked true
    place_id 1
  end

  factory :photo4, class: Photo do
    instagram_id 4
    image_low_resolution "http://distilleryimage2.s3.amazonaws.com/63d68d005e2211e3a0fb12e17bb388ef_6.jpg"
    tags "[\"foodporn\"]"
    checked true
    place_id 1
  end

  factory :photo5, class: Photo do
    instagram_id 5
    image_low_resolution "http://distilleryimage8.s3.amazonaws.com/845cc2ce5e2211e3a67212773ddcd17e_6.jpg"
    tags "[\"foodporn\"]"
    checked true
    place_id 1
  end

  factory :photo6, class: Photo do
    instagram_id 6
    image_low_resolution "http://distilleryimage3.s3.amazonaws.com/fbd1e87e5e0f11e3a43a0acef2407122_6.jpg"
    tags "[\"foodporn\"]"
    checked true
    place_id 1
  end

  factory :photo7, class: Photo do
    instagram_id 7
    image_low_resolution "http://distilleryimage10.s3.amazonaws.com/8e0784d85e2411e3841612ed36e0866b_6.jpg"
    tags "[\"foodporn\"]"
    checked true
    place_id 1
  end

  factory :photo8, class: Photo do
    instagram_id 8
    image_low_resolution "http://distilleryimage11.s3.amazonaws.com/72140cc25df411e3a742120ef9859af7_6.jpg"
    tags "[\"foodporn\"]"
    checked true
    place_id 1
  end

  factory :photo9, class: Photo do
    instagram_id 9
    image_low_resolution "http://distilleryimage4.s3.amazonaws.com/dc2f1a865e1f11e3897f0ed1040e6426_6.jpg"
    tags "[\"foodporn\"]"
    checked true
    place_id 2
  end

  factory :photo10, class: Photo do
    instagram_id 10
    image_low_resolution "http://distilleryimage1.s3.amazonaws.com/8d14e8ae5e1f11e382ff0ef840307e44_6.jpg"
    tags "[\"foodporn\"]"
    checked true
    place_id 2
  end

  factory :photo11, class: Photo do
    instagram_id 11
    image_low_resolution "http://distilleryimage2.s3.amazonaws.com/4e4c1c645e1f11e38d441210643c776b_6.jpg"
    tags "[\"foodporn\"]"
    checked true
    place_id 2
  end

  factory :place1, class: Place do
    google_id 1
    name "Adriatic"
    types "[\"restaurant\"]"
    vicinity "333 opera quay, Sydney"
    latitude '-33.0'
    longitude '180.0'
  end

  factory :place2, class: Place do
    google_id 2
    name "Paramount Coffee Project"
    types "[\"restaurant\"]"
    vicinity "80 Commonwealth Street, Surry Hills"
    latitude '-33.0'
    longitude '181.0'
  end

end

