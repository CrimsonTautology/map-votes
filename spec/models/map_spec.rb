require 'spec_helper'

describe Map do
  context "adding a new map" do
    before do
      @map = Map.create!(name: "koth_crap")
    end

    it "gets it's map type from the map prefix" do
      type = @map.map_type
      name.should eq "King of the Hill"
    end

  end

end
