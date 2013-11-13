require 'spec_helper'

describe "Static pages" do

  subject { page }

  describe "GET /" do

    before do
      visit root_path
    end

    its(:status_code) { should eq 200}
    it { should have_link("", href: "/auth/steam")}

    describe "search bar" do
      before do
        FactoryGirl.create(:map, name: "koth_badlands")
        FactoryGirl.create(:map, name: "koth_viaduct")
        fill_in "search", with: "bad"
        click_on "Search"
      end
      it { should have_content("koth_badlands") }
      it { should_not have_content("koth_viaduct") }
    end

    context "logged in" do
      let!(:user) {FactoryGirl.create(:user)}
      before do
        login user
      end

      it { should have_content(user.nickname)}
      it { should have_content(user.avatar_url)}
      it { should have_link("Log Out", href: logout_path)}
    end

    describe "Recent events" do
      let!(:m1) {FactoryGirl.create(:map, name: "cp_map1")}
      let!(:m2) {FactoryGirl.create(:map, name: "cp_map2")}
      let!(:u1) {FactoryGirl.create(:user, nickname: "User1")}
      let!(:u2) {FactoryGirl.create(:user, nickname: "User2")}

      before do
        MapComment.write_message u1, m1, "test"
        Vote.cast_vote u1, m1, 1
        Vote.cast_vote u2, m1, -1
        MapComment.write_message u1, m2, "test"
        MapComment.write_message u2, m2, "test"
        MapComment.write_message u2, m1, "test"
        Vote.cast_vote u2, m2, 1
        visit root_path
      end

      it { should have_content("Added new map:  cp_map1") }
      it { should have_content("User1 commented on cp_map1") }
      it { should have_content("2 users voted on cp_map1") }
      it { should have_content("2 users commented on cp_map2") }
      it { should have_content("User2 voted on cp_map2") }

    end
  end
end
