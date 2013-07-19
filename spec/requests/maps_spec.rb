require 'spec_helper'

describe "Maps" do
  describe "GET /maps" do
    context "empty database" do
      before(:each) do
        Map.delete_all
        visit "/maps"
      end

      it "renders" do
        expect(page.status_code).to be(200)
      end

    end

    context "populated database" do
      map = FactoryGirl.create(:map)
      before(:each) do
        visit "/maps"
      end

      it "displays a list of maps" do
        expect(page).to have_selector "li", map.name
      end

      it "groups available map types" do
        expect(page).to have_selector "li", map.type.name
      end

    end
  end
end
