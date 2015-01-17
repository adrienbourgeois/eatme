require 'rails_helper'
require 'instagram_listener'
include InstagramListener

# TODO: refactor

describe "InstagramListener" do

  let(:google_result) { {
    vicinity: "3 Square st",
    name: "Chez Adrien",
    types: "[\"Restaurant\"]",
    latitude: '-34.0',
    longitude: '151.0',
    google_id: 100,
    city_code: 1,
    city_name: "Sydney"
  }
  }

  let(:place_instagram) { {
    'location' => { 'name' => 'Chez Adrien' },
    'link' => 'http://',
    'images' => { 'low_resolution' => { 'url' => 'http://' },
                  'thumbnail' => { 'url' => 'http://' },
                  'standard_resolution' => { 'url' => 'http://' } },
    'tags' => "['foodporn']"
  }}

  describe "google_places_match" do

    it "should create a new place in the db when there is a match" do
      allow(InstagramListener).to receive(:google_find).and_return(google_result)
      InstagramListener.google_places_match place_instagram, -34.0, 151.0, 1
      expect(Place.last.name).to eq "Chez Adrien"
    end

    it "should not create a new place in the db when there is no match" do
      allow(InstagramListener).to receive(:google_find)
      count1 = Place.count
      InstagramListener.google_places_match place_instagram, 0.0, 0.0, 1
      count2 = Place.count
      expect(count1).to eq count2
    end

  end

  describe "city_hash" do

    it "should returns false when the coord does not belong to a city in the list" do
      expect(InstagramListener.city_hash(0.0,0.0)).to eq(false)
    end

    it "should returns a hash with Sydney when the coord belongs to Sydney" do
      expect(InstagramListener.city_hash(-34.0,151.0)[:name]).to eq "Sydney"
    end

  end

end
