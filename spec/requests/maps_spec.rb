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
      fixtures :maps
      before(:each) do
        visit "/maps"
      end

    end
  end
end
