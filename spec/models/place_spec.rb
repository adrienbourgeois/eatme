require 'spec_helper'
require 'pp'
require 'rake'

describe Place do

  describe "close" do
    it "should find close places when there is" do
      close_places = Place.close(-33.0,181.0,3.0,1,10)
      close_places[0].name.should eq "Paramount Coffee Project"
    end
    it "should not find close places when there is not" do
      close_places = Place.close(-33.0,182.0,3.0,1,10)
      close_places.count.should eq 0
    end
  end

  describe "popular" do
    it "should order places by popularity" do
      Showmeurfood::Application.load_tasks
      Rake::Task['update_popular_places'].invoke
      popular_places = Place.popular
      popular_places[0].name.should eq "Adriatic"
      popular_places[1].name.should eq "Paramount Coffee Project"
    end
  end

end
