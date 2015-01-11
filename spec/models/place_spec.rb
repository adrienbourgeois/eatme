# == Schema Information
#
# Table name: places
#
#  id            :integer          not null, primary key
#  google_id     :integer
#  name          :string(255)
#  types         :string(255)
#  vicinity      :string(255)
#  latitude      :float
#  longitude     :float
#  created_at    :datetime
#  updated_at    :datetime
#  reviews_count :integer          default("0")
#  rate_average  :float            default("-1.0")
#  city_name     :string(255)
#  city_code     :integer
#

require 'rails_helper'

RSpec.describe Place, type: :model do

  describe 'creation' do
    let(:attr) do
      {
        google_id:1,
        name:'Adriatic',
        types:"[\"cafe\", \"food\", \"establishment\"]",
        vicinity:'30 Macquarie Street',
        latitude:30.0,
        longitude:-151.0,
        city_code:1,
        city_name:'Sydney',
      }
    end

    context 'valid attributes' do
      it { expect(Place.create(attr)).to be_valid }
    end

    context 'google_id is missing' do
      it { expect(Place.create(attr.merge({google_id:nil}))).to_not be_valid }
    end

    context 'google_id is not numerical' do
      it { expect(Place.create(attr.merge({google_id:'abc'}))).to_not be_valid }
    end

    context 'name is missing' do
      it { expect(Place.create(attr.merge({name:nil}))).to_not be_valid }
    end

    context 'types is missing' do
      it { expect(Place.create(attr.merge({types:nil}))).to_not be_valid }
    end

    context 'vicinity is missing' do
      it { expect(Place.create(attr.merge({vicinity:nil}))).to_not be_valid }
    end

    context 'latitude is missing' do
      it { expect(Place.create(attr.merge({latitude:nil}))).to_not be_valid }
    end

    context 'latitude is not numerical' do
      it { expect(Place.create(attr.merge({latitude:'abc'}))).to_not be_valid }
    end

    context 'longitude is missing' do
      it { expect(Place.create(attr.merge({longitude:nil}))).to_not be_valid }
    end

    context 'longitude is not numerical' do
      it { expect(Place.create(attr.merge({longitude:'abc'}))).to_not be_valid }
    end

    context 'city_code is missing' do
      it { expect(Place.create(attr.merge({city_code:nil}))).to_not be_valid }
    end

    context 'city_name is missing' do
      it { expect(Place.create(attr.merge({city_name:nil}))).to_not be_valid }
    end

  end

  describe 'associations' do
    describe '#photos' do
      subject { FactoryGirl.create(:place) }
      let!(:photo) { FactoryGirl.create(:photo,place:subject) }

      it { expect(subject).to respond_to(:photos) }

      it "returns the photos associated to the place" do
        expect(subject.photos).to include(photo)
      end

      it "does not return other photos" do
        other_photo = FactoryGirl.create(:photo)
        expect(subject.photos).to_not include(other_photo)
      end

      describe 'dependent destroy' do
        it { expect{ subject.destroy}.to change{Photo.count}.by(-1) }
      end
    end

    describe '#reviews' do
      subject { FactoryGirl.create(:place) }
      let!(:review) { FactoryGirl.create(:review,place:subject) }

      it { expect(subject).to respond_to(:reviews) }

      it "returns the reviews associated to the place" do
        expect(subject.reviews).to include(review)
      end

      it "does not return other reviews" do
        other_review = FactoryGirl.create(:review)
        expect(subject.reviews).to_not include(other_review)
      end

      describe 'dependent destroy' do
        it { expect{ subject.destroy}.to change{Review.count}.by(-1) }
      end
    end
  end

  describe ".close" do
    subject { Place }
    let!(:place) { FactoryGirl.create(:place,latitude:-33.0,longitude:181.0) }
    let!(:photo) { FactoryGirl.create(:photo,place:place,tags:"[\"pizza\"]") }

    it { expect(subject).to respond_to(:close) }

    context 'place within search area' do
      context 'no filter_keyword' do
        it { expect(Place.close(-33.0,181.0,"3.0")).to include(place) }
      end

      context 'with filter_keyword' do
        context 'place does not contain any dishes matching the filter filter_keyword' do
          it { expect(Place.close(-33.0,181.0,"3.0",'ribs')).to_not include(place) }
        end

        context 'place contains at least one dish matching the filter filter_keyword' do
          it { expect(Place.close(-33.0,181.0,"3.0",'pizza')).to include(place) }
        end
      end
    end

    context 'place not withing search area' do
      it { expect(Place.close(-33.0,185.0,"3.0")).to_not include(place) }
    end

    context 'radius not authorized' do
      it { expect { Place.close(-33.0,182.0,"-1.0") }.to raise_error(ArgumentError) }
    end

    context 'filter_keyword not authorized' do
      it {expect { Place.close(-33.0,181.0,"3.0",'not_authorized_keyword') }.to raise_error(ArgumentError) }
    end
  end

end
