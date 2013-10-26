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
  end
end
