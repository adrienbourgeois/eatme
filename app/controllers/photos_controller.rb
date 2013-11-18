class PhotosController < ApplicationController

  def index
    @photos = Photo.all.where(checked:true).order(created_at: :desc).limit(30)
  end

end
