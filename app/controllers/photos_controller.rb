class PhotosController < ApplicationController

  PER_PAGE = 9

  def index
    @photos = Photo.page(params[:page]).per(PER_PAGE).order(id: :desc).checked

    respond_to do |format|
      format.html
      format.json { render json: @photos, include: :place }
    end
  end

end
