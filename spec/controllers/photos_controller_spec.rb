require 'rails_helper'

describe PhotosController do
  #render_views

  it "should render a json object containing the last photos and the corresponding places" do
    get 'index'
    response.body.should have_content("http://distilleryimage2.s3.amazonaws.com/4e4c1c645e1f11e38d441210643c776b_6.jpg")
    response.body.should have_content("Paramount Coffee Project")
  end

end
