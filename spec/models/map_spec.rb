require 'spec_helper'

describe Map do
  context "adding a new map" do
    let(:map) {FactoryGirl.create(:map, name: "koth_crap_b1")}

    subject{ map }

    its(:map_type) { should eql MapType.find_by_prefix("koth" )}

  end

  describe "#base_map_name" do
    let(:map) {FactoryGirl.create(:map, name: "cp_base_name_v1")}
    subject{ map }

    its(:base_map_name) { should eql  "base_name"}

    it "matches related maps" do
      other = FactoryGirl.create(:map, name:  "koth_base_name_final")
      expect(other.base_map_name).to eql map.base_map_name
    end

    it "ignores maps without a prefix" do
      map.name = "avanti_b1"
      expect(map.base_map_name).to eql "avanti"
    end

  end


end
