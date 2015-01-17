require "rails_helper"

feature "Close Places", js: true  do

  it "has a welcome message" do
    visit "/#/close_places"
    expect(page).to have_content("Welcome")
  end

  xit "should be close_places as home page" do
    visit root_path
    page.should have_selector("div.edgetoedge.current#close_places")
  end

  xit "should find close places from your position (1)" do
    visit root_path
    simulate_location(-33.0,180.0)
    select "0.1", from: 'distance'
    find("a#search").click
    wait_for_ajax
    page.should have_content("Adriatic")
  end

  xit "should find close places from your position (2)" do
    visit root_path
    simulate_location(-33.0,181.0)
    select "0.1", from: 'distance'
    find("a#search").click
    wait_for_ajax
    page.should have_content("Paramount Coffee Project")
  end

  xit "should display a message if there is no close places from your position" do
    visit root_path
    simulate_location(-34.0,180.0)
    select "0.1", from: 'distance'
    find("a#search").click
    wait_for_ajax
    page.should have_content("No results found")
  end

end
