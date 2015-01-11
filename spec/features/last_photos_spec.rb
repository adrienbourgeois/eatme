require "rails_helper"

feature "Last Photos" do
  before do
    place = FactoryGirl.create(:place,name:'My beautiful restaurant')
    FactoryGirl.create(:photo,place:place)
  end

  scenario "User check the last photos" do
    visit "/photos"
    expect(page).to have_text("My beautiful restaurant")
  end
end