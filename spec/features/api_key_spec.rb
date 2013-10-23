require 'spec_helper'

describe "Static pages" do

  subject { page }

  describe "GET /api_keys" do

    context "not-logged in as admin" do
      let!(:user) {FactoryGirl.create(:user)}
      before do
        login user
        visit api_keys_path
      end

      its(:status_code) { should eq 403}
    end

    context "logged in as admin" do
      let!(:user) {FactoryGirl.create(:admin)}
      let!(:api_key) {FactoryGirl.create(:api_key)}

      before do
        login user
        visit api_keys_path
      end

      its(:status_code) { should eq 200}

      it {should have_content(api_key.name)}
      it {should have_content(api_key.access_token)}

      it "lets you add new tokens" do
        fill_in "Name", with: "Test Key"
        click_on :submit
        expect(page).to have_content("Test Key")
      end

      it "lets you delete tokens" do
        click_on "delete"
        expect(page).to_not have_content(api_key.name)
      end
    end

  end
end
