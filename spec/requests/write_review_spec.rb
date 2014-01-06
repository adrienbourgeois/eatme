require 'spec_helper'
require 'pp'

describe "Reviews", js: true  do

  let(:user) { stub(id: 1,
                    name: 'adrien',
                    image: 'http://graph.facebook.com/100003759431926/picture?type=square',
                   )}

  describe "when logged in" do

    it "should have a form to submit review when logged in" do
      ApplicationController.any_instance.stub(current_user: user)
      visit '#just_eaten'
      wait_for_ajax
      first("button.show_place").click
      wait_for_ajax
      page.should have_selector("form[name='review']")
    end

    xit "should print the review when a review is submitted" do
      ApplicationController.any_instance.stub(current_user: user)
      visit '#just_eaten'
      wait_for_ajax
      first("button.show_place").click
      wait_for_ajax
      find("textarea").set("Good Restaurant!")
      first("img[title='good']").click
      find("a#submit_review").click
      wait_for_ajax
      page.should have_content("Good Restaurant!")
    end

  end

  it "should not have a submit review form when not logged in" do
    visit '#just_eaten'
    wait_for_ajax
    first("button.show_place").click
    wait_for_ajax
    page.should_not have_selector("form[name='review']")
  end

end
