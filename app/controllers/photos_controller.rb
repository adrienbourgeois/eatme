include ActionView::Helpers::DateHelper

class PhotosController < ApplicationController

  PER_PAGE = 9

  def index
    photos = Photo.checked.where('created_at > (?)',24.hours.ago).page(params[:page]).per(PER_PAGE).order(created_at: :desc)
    photos_js = JSON.parse(photos.to_json(include: :place))
    photos_js.each { |photo| photo['minutes_ago'] = "#{time_ago_in_words(photo['updated_at'])} ago" }
    render json: photos_js
  end

end
