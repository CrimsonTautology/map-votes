require 'spec_helper'

describe "Map pages" do

  subject { page }

  describe "GET /maps" do
    context "empty database" do
      before(:each) do
        Map.delete_all
        visit maps_path
      end

      it { should have_status_code(200)}

    end

    context "populated database" do
      let!(:map) {FactoryGirl.create(:map)}
      before(:each) do
        visit maps_path
      end

      it { should have_link(map.name, href: map_path(map))}
      it { should have_content(map.map_type.name)}

    end
  end #/maps

  describe "GET /maps/:id" do
    let!(:map) {FactoryGirl.create(:map)}

    before(:each) do
      visit "/maps/#{@map.name}"
    end

    it { should have_status_code(200)}
    it { should have_content(map.name)}

    context "no comments" do
      before(:each) do
        MapComment.delete_all
      end

      it { should have_content("No comments")}
    end

    context "with comments" do
      let!(:comment) {FactoryGirl.create(:comment)}
      it { should have_content(comment.comment)}

    end

    context "user logged in" do
      pending "shows add new comment textbox"
      pending "adding a comment"
      pending "removing a comment"
      pending "voting"

    end
    context "user logged out" do
      pending "does not show add new comment textbox"
      pending "not prompted to vote"

    end
  end#/maps/:id
end
