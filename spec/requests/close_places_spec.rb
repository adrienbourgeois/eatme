require 'spec_helper'
require 'pp'

describe "ClosePlaces" do
  it "find no results" do
    visit root_path
    pp page.body
    pp "======================whhhhhhhhhhhhhhhhhhhhaaaaaaaaaaaaaaaaaat"
    page.should have_content("EatMe")
    #page.should have_content("Account")
  end
end
