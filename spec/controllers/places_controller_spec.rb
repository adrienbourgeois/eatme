require 'spec_helper'
require 'pp'
require 'rake'
require 'pry'

describe PlacesController do

  it "should render a json object containing the popular places when the param page is popular" do
    Information.create(name:'popular_places')
    Showmeurfood::Application.load_tasks
    Rake::Task['update_popular_places'].invoke
    controller.stub!(:params).and_return({ page:'popular' })
    get 'index'
    response_json = JSON.parse response.body
    response_json[0]['name'].should == "Adriatic"
  end

  it "should render a json object containing the close places when there are a latitude/longitude in the params" do
    controller.stub!(:params).and_return({ latitude:'-33.0', longitude:'180.0', radius: '0.1' })
    get 'index'
    response_json = JSON.parse response.body
    response_json.length.should == 1
    response_json[0]['name'].should == "Adriatic"
  end

end
