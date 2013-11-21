class PlacesController < ApplicationController
  def index
    @places = Place.popular_places
  end
end
