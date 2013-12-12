require 'spec_helper'

describe Photo do

  describe "latest" do
    it "should return the last photo" do
      last_photo = Photo.latest(1,1)[0]
      last_photo.instagram_id.should eq 11
    end
  end

end
