require 'spec_helper'

shared_examples_for "UserInfo" do 
  subject {page}
  context "logged in" do

    its(:status_code) { should eq 200}
    it {should have_content(user.nickname)}
    it {should have_link("", href: user.profile)}

    context "with voted maps" do
      let!(:map1) {FactoryGirl.create(:map)}
      let!(:map2) {FactoryGirl.create(:map)}
      let!(:vote1) {FactoryGirl.create(:vote, user: user, value: 1, map: map1)}
      let!(:vote2) {FactoryGirl.create(:vote, user: user, value: -1, map: map2)}

      before do
        visit user_path(user)
      end

      it {should have_link(map1.name, href: map_path(map1))}
      it {should have_link(map2.name, href: map_path(map2))}
    end

    context "with favorited maps" do
      let!(:map) {FactoryGirl.create(:map)}
      let!(:map_favorite) {FactoryGirl.create(:map_favorite, user: user, map: map)}

      before do
        visit user_path(user)
      end

      it {should have_link(map.name, href: map_path(map))}
      it {should have_link("Manage Favorites", href: user_map_favorites_path(user))}
    end


    
  end
end

shared_examples_for "RejectOtherUsers" do
  context "Not logged in" do
    before do
      visit "/users/#{user.uid}"
    end

    its(:status_code) { should eq 401}
  end

  context "Logged in as wrong user" do
    let!(:viewer) {FactoryGirl.create(:user)}
    before do
      login viewer
      visit "/users/#{user.uid}"
    end

    its(:status_code) { should eq 401}
  end

  context "Logged in as correct user" do
    before do
      login user
      visit "/users/#{user.uid}"
    end

    its(:status_code) { should eq 200}
  end

end

shared_examples_for "ModeratorFunction" do

end

describe "Map pages" do
  #raise page.body.to_yaml

  subject { page }

  pending "GET /users/:id" do
    let!(:user) {FactoryGirl.create(:user)}

    it_should_behave_like "RejectOtherUsers"

    context "Logged in as correct user" do
      before do
        login user
        visit "/users/#{user.uid}"
      end

      it_should_behave_like "UserInfo"
    end

    context "Logged in as moderator" do
      let!(:viewer) {FactoryGirl.create(:user, moderator: true)}
      before do
        login viewer
        visit "/users/#{user.uid}"
      end

      it_should_behave_like "UserInfo"

      it { should have_link("Ban User", href: ban_user_path(user))}
    end

    context "Logged in as admin" do
      let!(:viewer) {FactoryGirl.create(:user, admin: true)}
      before do
        login viewer
        visit "/users/#{user.uid}"
      end

      it_should_behave_like "UserInfo"

      it { should have_link("Ban User", href: ban_user_path(user))}
    end

  end

  pending "GET /users/:uid/map_favorites" do
    let!(:user) {FactoryGirl.create(:user)}

    it_should_behave_like "RejectOtherUsers"
  end

  pending "GET /users/:uid/ban" do
    let!(:user) {FactoryGirl.create(:user)}
    let!(:viewer) {FactoryGirl.create(:user)}

  end

end
