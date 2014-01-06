require 'spec_helper'
require 'instagram_listener'
require 'pp'
include InstagramListener

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
      InstagramListener.stub(google_find: google_result)
      InstagramListener.google_places_match place_instagram, -34.0, 151.0, 1
      Place.last.name.should eq "Chez Adrien"
    end

    it "should not create a new place in the db when there is no match" do
      InstagramListener.stub(google_find:nil)
      count1 = Place.count
      InstagramListener.google_places_match place_instagram, 0.0, 0.0, 1
      count2 = Place.count
      count1.should eq count2
    end

  end

  describe "city_hash" do

    it "should returns false when the coord does not belong to a city in the list" do
      InstagramListener.city_hash(0.0,0.0).should == false
    end

    it "should returns a hash with Sydney when the coord belongs to Sydney" do
      InstagramListener.city_hash(-34.0,151.0)[:name].should eq "Sydney"
    end

  end

end
