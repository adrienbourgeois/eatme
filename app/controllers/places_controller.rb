class PlacesController < ApplicationController

  def index
    @places = nil
    @places = Place.popular_places if params[:page] == "popular"
    @places = Place.near([params[:latitude],params[:longitude]], 0.3) if params[:latitude] and params[:longitude]
    render json: @places.to_json(include: :photos)
  end

  def show
    @place = Place.find params[:id]
  end

end
