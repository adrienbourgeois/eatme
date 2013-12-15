class PagesController < ApplicationController

  def home
    @number_of_photos = Photo.where(checked:true).count
    @photos_ex = Photo.limit(10)
  end

end
