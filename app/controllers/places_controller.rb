class PlacesController < ApplicationController

  def index
    @places = Place.popular_places if params[:page] == "popular"
    @places = Place.near([params[:latitude],params[:longitude]], 0.3) if params[:latitude] and params[:longitude]
  end

  def show
    @place = Place.find params[:id]
  end

end
