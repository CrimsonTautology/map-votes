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

  describe "#find_related_maps_deep" do
    let(:map) {FactoryGirl.create(:map, name: "cp_base_name_v1")}
    subject{ map.find_related_maps_deep.map(&:name) }

    before do
      FactoryGirl.create(:map, name: "koth_base_name_v1")
      FactoryGirl.create(:map, name: "cp_base_name")
      FactoryGirl.create(:map, name: "cp_base_name_final")
      FactoryGirl.create(:map, name: "cp_dustbowl")
      FactoryGirl.create(:map, name: "koth_place_v1")
      FactoryGirl.create(:map, name: "cp_secret_base_b1")
    end

    it { should include( "koth_base_name_v1") }
    it { should include( "cp_base_name") }
    it { should include( "cp_base_name_final") }

    it { should_not include( "cp_dustbowl") }
    it { should_not include( "koth_place_v1") }
    it { should_not include( "cp_secret_base_b1") }

  end


end
