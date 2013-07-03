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

  describe "#base_name" do
    before(:each) {@map = Map.create!(name: "cp_base_name_v1") }
    it "has a base name" do
      @map.base_name.should eql "base_name"
    end

    it "matches related maps" do
      @other = Map.create!(name: "koth_base_name")
      @other.base_name.should eql @map.base_name
    end

    it "ignores maps without a prefix" do
      @other = Map.create!(name: "avanti_b1")
      @other.base_name.should eql "avanti"
    end
    end

  end


end
