require 'spec_helper'
require 'pp'

describe "JqtouchInterface", js: true  do

  before do
    I18n.enforce_available_locales = false
  end

  it "should be close_places as home page" do
    visit root_path
    page.should have_selector("div.edgetoedge.current#close_places")
  end

  it "should find close places from your position (1)" do
    visit root_path
    simulate_location(-33.0,180.0)
    select "0.1", from: 'distance'
    wait_for_ajax
    page.should have_content("Adriatic")
  end

  it "should find close places from your position (2)" do
    visit root_path
    simulate_location(-33.0,181.0)
    select "0.1", from: 'distance'
    wait_for_ajax
    page.should have_content("Paramount Coffee Project")
  end

  it "should display a message if there is no close places from your position" do
    visit root_path
    simulate_location(-34.0,180.0)
    select "0.1", from: 'distance'
    wait_for_ajax
    page.should have_content("No results found")
  end

  it "should display last recorded photo in 'just eaten' section" do
    visit root_path
    find("a", text: 'Menu').click
    find("a", text: 'Just Eaten').click
    wait_for_ajax
    page.should have_content("Adriatic")
    page.should have_content("Paramount Coffee Project")
  end

end
