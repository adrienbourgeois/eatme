class PagesController < ApplicationController

  def home
    @number_of_photos = Photo.all.where(checked:true).count
  end

end
