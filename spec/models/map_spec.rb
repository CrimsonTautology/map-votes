require 'spec_helper'

describe Map do
  context "adding a new map" do
    before(:each) do
      @map = Map.create!(name: "koth_crap_b1")
    end

    it "gets it's map type from the map prefix" do
      type = @map.map_type
      expect(type.name).to eq "King of the Hill"
    end

  end

  describe "#base_map_name" do
    before(:each) {@map = Map.create!(name: "cp_base_name_v1") }
    it "has a base name" do
      expect(@map.base_map_name).to eql "base_name"
    end

    it "matches related maps" do
      @other = Map.create!(name: "koth_base_name_final")
      expect(@other.base_map_name).to eql @map.base_map_name
    end

    it "ignores maps without a prefix" do
      @other = Map.create!(name: "avanti_b1")
      expect(@other.base_map_name).to eql "avanti"
    end

  end


end
