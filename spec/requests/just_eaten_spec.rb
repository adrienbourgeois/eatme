require 'spec_helper'
require 'pp'

describe "Just Eaten", js: true  do
  it "should display last recorded photo in 'just eaten' section" do
    visit root_path
    find("a", text: 'Menu').click
    find("a", text: 'Just Eaten').click
    wait_for_ajax
    page.should have_content("Adriatic")
    page.should have_content("Paramount Coffee Project")
  end
end
