require 'spec_helper'

describe Map do
  let(:map) {FactoryGirl.create(:map, name: "cp_base_name_v1")}
  subject{ map }

  context "adding a new map should get the correct prefix" do
    its(:map_type) { should eql MapType.find_by_prefix("cp" )}
  end

  describe "#base_map_name" do
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

    it { should_not include( "cp_base_name_v1") }
    it { should_not include( "cp_dustbowl") }
    it { should_not include( "koth_place_v1") }
    pending { should_not include( "cp_secret_base_b1") }

  end

  describe "#to_param" do
    subject {map.to_param}
    it { should eql(map.name.parameterize)}
  end

  describe "voting methods" do
    before do
      FactoryGirl.create(:vote, map: map, value: 1)
      FactoryGirl.create(:vote, map: map, value: 1)
      FactoryGirl.create(:vote, map: map, value: 1)
      FactoryGirl.create(:vote, map: map, value: 0)
      FactoryGirl.create(:vote, map: map, value: -1)
    end

    its(:total_votes) {should eq(4)}
    its(:liked_by) {should have(3).items}
    its(:hated_by) {should have(1).items}
  end

end
