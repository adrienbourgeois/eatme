class PlacesController < ApplicationController

  PER_PAGE = 3

  def index
    @places = nil
    if params[:page] == "popular"
      @places = Place.popular
      @places = @places.to_json
    end
    if params[:latitude] and params[:longitude]
      @places = Place.page(params[:page]).per(PER_PAGE).close(params[:latitude], params[:longitude], params[:radius], params[:filter_keyword])
      Place.filter_keyword = params[:filter_keyword]
      @places = @places.to_json#(methods: :photos_filtered)
    end
    render json: @places
  end

  def show
    @place = Place.find params[:id]
    render json: @place.to_json(include: {photos: {}, reviews: {include: :user}})
  end

end
