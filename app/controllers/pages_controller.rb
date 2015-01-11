class PagesController < ApplicationController

  def home
    @number_of_photos = 1000000
  end

  def signin
    redirect_to home_path if current_user
  end

end
