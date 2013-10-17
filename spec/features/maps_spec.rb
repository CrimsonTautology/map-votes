require 'spec_helper'

describe "Map pages" do

  subject { page }

  describe "GET /maps" do
    context "empty database" do
      before(:each) do
        Map.delete_all
        visit maps_path
      end

      its(:status_code) { should eq 200}

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
      visit "/maps/#{map.name}"
    end

    it { should have_content(map.name)}
    it { should have_content(map.map_type.name)}

    context "no comments" do
      before(:each) do
        MapComment.delete_all
        visit map_path(map)
      end

      it { should have_content("All Comments (0)")}
    end

    context "with comments" do
      let!(:comment) {FactoryGirl.create(:map_comment, map: map)}
      before do
        visit map_path(map)
      end

      it { should have_content(comment.comment)}
      it { should have_content(comment.user.nickname)}

    end

    context "with up votes" do
      let!(:user) {FactoryGirl.create(:user, nickname: "Upvote McGee")}
      let!(:vote) {FactoryGirl.create(:vote, map: map, user: user, value: 1)}

      before do
        visit map_path(map)
      end

      it { should have_content(user.nickname)}
      it { should have_content("Liked by")}
    end

    context "with down votes" do
      let!(:user) {FactoryGirl.create(:user, nickname: "Map hater")}
      let!(:vote) {FactoryGirl.create(:vote, map: map, user: user, value: -1)}

      before do
        visit map_path(map)
      end

      it { should have_content(user.nickname)}
      it { should have_content("Hated by")}
      it { should have_selector('span', class: 'down-vote', text: '1')}
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
#You must be logged in to leave a comment
    end
  end#/maps/:id
end
