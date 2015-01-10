# == Schema Information
#
# Table name: photos
#
#  id                        :integer          not null, primary key
#  instagram_id              :integer
#  image_low_resolution      :string(255)
#  image_thumbnail           :string(255)
#  image_standard_resolution :string(255)
#  instagram_url             :string(255)
#  instagram_body_req        :text
#  tags                      :string(255)
#  created_at                :datetime
#  updated_at                :datetime
#  checked                   :boolean          default("f")
#  place_id                  :integer
#

require 'rails_helper'

RSpec.describe Photo, type: :model do

  describe 'creation' do
    let(:attr) do
      {
        instagram_id:1,
        image_low_resolution:'image-example.png',
        image_thumbnail:'image-example.png',
        image_standard_resolution:'image-example.png',
        instagram_url:'http://instagram.com/123',
        instagram_body_req:'body req example',
        tags:"[\"restaurant\"]",
        checked:true,
      }
    end

    context 'arguments are valid' do
      it { expect(Photo.create(attr)).to be_valid }
    end

    context 'instagram_id is missing' do
      it { expect(Photo.create(attr.merge({instagram_id:nil}))).to_not be_valid }
    end

    context 'instagram_id is not a number' do
      it { expect(Photo.create(attr.merge({instagram_id:'hello'}))).to_not be_valid }
    end

    context 'image_low_resolution is missing' do
      it { expect(Photo.create(attr.merge({image_low_resolution:nil}))).to_not be_valid }
    end

    context 'image_thumbnail is missing' do
      it { expect(Photo.create(attr.merge({image_thumbnail:nil}))).to_not be_valid }
    end

    context 'image_standard_resolution is missing' do
      it { expect(Photo.create(attr.merge({image_standard_resolution:nil}))).to_not be_valid }
    end

    context 'instagram_url is missing' do
      it { expect(Photo.create(attr.merge({instagram_url:nil}))).to_not be_valid }
    end

    context 'instagram_body_req is missing' do
      it { expect(Photo.create(attr.merge({instagram_body_req:nil}))).to_not be_valid }
    end

    context 'tags is missing' do
      it { expect(Photo.create(attr.merge({tags:nil}))).to_not be_valid }
    end

    context 'checked is missing' do
      it { expect(Photo.create(attr.merge({checked:nil}))).to_not be_valid }
    end
  end

  describe 'associations' do
    describe '.place' do
      subject { FactoryGirl.create(:photo) }

      it { expect(subject).to respond_to(:place) }

      it "returns the place associated" do
        place = FactoryGirl.create(:place)
        subject.place = place
        subject.save
        expect(subject.reload.place).to eq(place)
      end
    end
  end

end
