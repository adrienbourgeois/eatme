require "rails_helper"
include Capybara::Angular::DSL
require 'selenium/webdriver'

feature "Close Places", js: true  do

  describe 'page elements' do
    it "has a select box for the filter keyword" do
      visit "/#/close_places"
      expect(page.has_xpath?("//select[@id='filter-keyword']")).to eq(true)
    end

    it "has a select box for the radius" do
      visit "/#/close_places"
      expect(page.has_xpath?("//select[@ng-model='currentRadi']")).to eq(true)
    end
  end

  describe 'feature' do
    # To properly test that feature, we should be able to stub the html5 geolocation
    # (which is used by the application). There is no out of the box solution for that problem
    # with selenium.
    # Those guys here: http://lucaguidi.com/2011/02/13/html5-geolocation-testing-with-cucumber.html
    # seem to have a working solution but the hack seems pretty heavy
    # 
    # That guy here: http://grosser.it/2012/04/19/testing-geolocation-with-capybara-selenium-firefox/
    # has a semi-working solution. The problem being he modifies the geolocation after
    # the page is loaded (as he needs the capybara 'page' object) and so his solution is useless
    # in some test cases
    #
    # Finaly I found that the best solution was to create a profile for firefox that force
    # the geo location to be [-33.0,181.0]. In a way, the geolocation is stubbed.
    # All you need to do to use that profile is to:
    #   Capybara.current_driver = :stub_geolocation
    # refs: 
    # http://watirmelon.com/2014/09/18/faking-geolocation-in-selenium-webdriver-with-firefox/
    # http://stackoverflow.com/questions/20009266/selenium-testing-with-geolocate-firefox-keeps-turning-it-off
    # http://stackoverflow.com/questions/19166480/user-agent-testing-using-capybara-not-working
    # 
    # I think it'd be interesting to make a gem out of that. A gem that would allow to stub
    # the geolocation with selenium


    before { Capybara.current_driver = :stub_geolocation }

    context 'no options' do
      context 'restaurants exist within area' do
        before do
          place = FactoryGirl.create(:place,latitude:-33.0,longitude:181.0,name:'Adriatic Restaurant')
          # Create a dish for the restaurant
          FactoryGirl.create(:photo,place:place,tags:"[\"pizza\"]")
        end

        it 'shows restaurants in the area' do
          # select "pizza", from: 'filter-keyword'
          visit "/#/close_places"
          sleep 6.0
          expect(page).to have_content("Adriatic Restaurant")
        end

        context 'with a tag' do
          it 'shows restaurants with the tag' do
            visit "/#/close_places"
            select "pizza", from: 'filter-keyword'
            sleep 6.0
            expect(page).to have_content("Adriatic Restaurant")
          end

          it 'does not show restaurants without the tag' do
            visit "/#/close_places"
            select "ribs", from: 'filter-keyword'
            sleep 6.0
            expect(page).to_not have_content("Adriatic Restaurant")
          end
        end
      end

      context 'no restaurant exist within area' do
        before do
          place = FactoryGirl.create(:place,latitude:-10.0,longitude:150.0,name:'Adriatic Restaurant')
          # Create a dish for the restaurant
          FactoryGirl.create(:photo,place:place,tags:"[\"pizza\"]")
        end

        it 'does not show any restaurant' do
          visit "/#/close_places"
          sleep 6.0
          expect(page).to_not have_content("Adriatic Restaurant")
        end
      end
    end
  end

end
