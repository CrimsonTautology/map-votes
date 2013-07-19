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
      before(:each) do
        @map = FactoryGirl.build(:map)
        visit "/maps"
      end

      it "displays a list of maps" do
        expect(page).to have_selector "li", @map.name
      end

      it "groups available map types" do
        expect(page).to have_selector "li", @map.map_type.name
      end

    end
  end #/maps
  describe "GET /maps/:id" do
    before(:each) do
      @map = FactoryGirl.build(:map)
      visit "/maps/#{map.name}"
    end
  end#/maps/:id
end
