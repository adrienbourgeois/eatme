class PhotosController < ApplicationController

  def index
    respond_to do |format|
      format.html do
        @photos = Photo.all.where(checked:true).order(created_at: :desc).page(params[:page] || 1).per(9)
      end
      format.mobile do
        @photos = Photo.all.where(checked:true).order(created_at: :desc).page(params[:page] || 1).per(9)
      end
      format.json do
        @photos = Photo.all.where(checked:true).order(created_at: :desc).page(params[:page]).per(9)
        render json: @photos.to_json(include: :place)
      end
    end
  end

end
