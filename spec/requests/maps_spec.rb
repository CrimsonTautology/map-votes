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
        @map = FactoryGirl.create(:map)
        visit "/maps"
      end

      it "displays a list of maps" do
        expect(page).to have_content @map.name
      end

      it "groups available map types" do
        expect(page).to have_content @map.map_type.name
      end

    end
  end #/maps
  describe "GET /maps/:id" do
    before(:each) do
      @map = FactoryGirl.create(:map)
      visit "/maps/#{@map.name}"
    end
    it "renders" do
      expect(page.status_code).to be(200)
    end
    it "displays the current map" do
      expect(page).to have_content @map.name
    end

    context "no comments" do
      before(:each) do
        MapComment.delete_all
      end
      it "Mentions there are no comments" do
        expect(page).to have_content "No Comments"
      end
    end
    context "with comments" do
      before(:each) do
        @comment = FactoryGirl.create(:comment)
      end

      it "displays comments" do
        expect(page).to have_content @comment.comment
      end

    end

    context "user logged in" do
      pending "shows add new comment textbox"

    end
    context "user logged out" do
      pending "does not show add new comment textbox"

    end
  end#/maps/:id
end
