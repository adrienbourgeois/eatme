class PlacesController < ApplicationController

  PER_PAGE = 3

  def index
    @places = nil
    if params[:page] == "popular"
      @places = Place.popular
      @places = @places.to_json(include: :photos)
    end
    if params[:latitude] and params[:longitude]
      @places = Place.close(params[:latitude], params[:longitude], params[:radius]).page(params[:page]).per(PER_PAGE)
      @places = @places.to_json
    end
    render json: @places
  end

  def show
    @place = Place.find params[:id]
    render json: @place.to_json(include: :photos)
  end

end
