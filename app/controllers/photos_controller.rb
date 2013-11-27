class PhotosController < ApplicationController

  def index
    respond_to do |format|
      format.html { @number_of_photos = Photo.all.where(checked:true).count }
      format.json { render json: Photo.get_last_photos(params[:page]) }
    end
  end

end
