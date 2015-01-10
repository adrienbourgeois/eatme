require 'rails_helper'

RSpec.describe PhotosController, type: :controller do
  describe '#index' do
    subject{ get :index }
    let(:photo) { FactoryGirl.create(:photo) }
    let(:unchecked_photo) { FactoryGirl.create(:photo,checked:false) }

    it { expect(subject).to be_success }

    describe '@photos' do
      it "assigned to the last photos" do
        subject
        expect(assigns(:photos)).to include(photo)
      end

      it "does not include unchecked photos" do
        subject
        expect(assigns(:photos)).to_not include(unchecked_photo)
      end
    end
  end

  # it "should render a json object containing the last photos and the corresponding places" do
  #   get 'index'
  #   response.body.should have_content("http://distilleryimage2.s3.amazonaws.com/4e4c1c645e1f11e38d441210643c776b_6.jpg")
  #   response.body.should have_content("Paramount Coffee Project")
  # end

end
