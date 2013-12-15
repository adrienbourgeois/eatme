class PagesController < ApplicationController

  def home
    @number_of_photos = Photo.where(checked:true).count
  end

end
