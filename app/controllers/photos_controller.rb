class PhotosController < ApplicationController

  def index
    render json: Photo.get_last_photos(params[:page])
  end

end
