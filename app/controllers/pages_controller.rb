class PagesController < ApplicationController

  def home
    @number_of_photos = Photo.where(checked:true).count
  end

  def signin
    redirect_to root_path if current_user
  end

end
