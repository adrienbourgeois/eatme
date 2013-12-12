class PlacesController < ApplicationController

  PER_PAGE = 1

  def index
    @places = nil
    @places = Place.popular if params[:page] == "popular"
    @places = Place.close(params[:latitude], params[:longitude], params[:rayon], params[:page], PER_PAGE) if params[:latitude] and params[:longitude]
    render json: @places.to_json(include: :photos)
  end

  def show
    @place = Place.find params[:id]
    render json: @place.to_json(include: :photos)
  end

end
