include ActionView::Helpers::DateHelper

class PhotosController < ApplicationController

  PER_PAGE = 9

  def index
    @photos = Photo.order(id: :desc).checked.page(params[:page]).per(PER_PAGE)
  end

end
