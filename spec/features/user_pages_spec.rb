require 'spec_helper'

shared_examples_for "UserInfo" do 
  subject {page}
  context "logged in" do

    its(:status_code) { should eq 200}
    it {should have_content(user.nickname)}
    it {should have_link("", href: user.profile_url)}

    context "with voted maps" do
      let!(:map1) {FactoryGirl.create(:map)}
      let!(:map2) {FactoryGirl.create(:map)}
      let!(:vote1) {FactoryGirl.create(:vote, user: user, value: 1, map: map1)}
      let!(:vote2) {FactoryGirl.create(:vote, user: user, value: -1, map: map2)}

      before do
        visit user_path(user)
      end

      it "Lists liked maps" do
        within "#likes" do
          should have_link(map1.name, href: map_path(map1))
        end
      end

      it "Lists hated maps" do
        within "#hates" do
          should have_link(map2.name, href: map_path(map2))
        end
      end
    end

    context "with favorited maps" do
      let!(:map) {FactoryGirl.create(:map)}
      let!(:map_favorite) {FactoryGirl.create(:map_favorite, user: user, map: map)}

      before do
        visit user_path(user)
      end

      it {should have_link("Manage Favorites", href: user_map_favorites_path(user))}
    end
    
  end
end

shared_examples_for "Ban Users" do
  it { should have_link("Ban User", href: ban_user_path(user))}
  it { should_not have_link("Unban User", href: unban_user_path(user))}
  it "lets you ban users" do
    click_on "Ban User"
    expect(user).to be_banned
  end

  context "user is banned" do
    before {user.banned_at = Time.now}
    it { should_not have_link("Ban User", href: ban_user_path(user))}
    it { should have_link("Unban User", href: unban_user_path(user))}
    it "lets you unban users" do
      click_on "Unban User"
      expect(user).to_not be_banned
    end

  end

end


describe "User pages" do
  #raise page.body.to_yaml

  subject { page }

  pending "GET /users/:uid" do
    let!(:user) {FactoryGirl.create(:user)}

    context "Not logged in" do
      before do
        visit user_path(user)
      end

      its(:status_code) { should eq 403}
    end

    context "Logged in as wrong user" do
      let!(:viewer) {FactoryGirl.create(:user)}
      before do
        login viewer
        visit user_path(user)
      end

      its(:status_code) { should eq 403}
    end

    context "Logged in as correct user" do
      before do
        login user
        visit user_path(user)
      end

      its(:status_code) { should eq 200}
      it_should_behave_like "UserInfo"
    end

    context "Logged in as moderator" do
      let!(:viewer) {FactoryGirl.create(:user, moderator: true)}
      before do
        login viewer
        visit user_path(user)
      end

      it_should_behave_like "UserInfo"

      it_should_behave_like "Ban Users"
    end

    context "Logged in as admin" do
      let!(:viewer) {FactoryGirl.create(:user, admin: true)}
      before do
        login viewer
        visit user_path(user)
      end

      it_should_behave_like "UserInfo"
      it_should_behave_like "Ban Users"

    end

  end

  pending "GET /users/:uid/map_favorites" do
    let!(:user) {FactoryGirl.create(:user)}
  end

  pending "GET /users/:uid/ban" do
    let!(:user) {FactoryGirl.create(:user)}
    let!(:viewer) {FactoryGirl.create(:user)}

  end

end
