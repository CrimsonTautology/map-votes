require 'spec_helper'

describe Map do
  let(:map) {FactoryGirl.create(:map, name: "cp_base_name_v1")}
  subject{ map }

  its(:to_param){ should eql(map.name)}

  context "adding a new map should get the correct prefix" do
    its(:map_type) { should eql MapType.find_by_prefix("cp" )}
  end

  describe "#prefix" do
    its(:prefix) { should eql "cp"}
  end

  describe "#version" do
    it "matches common version letters" do
      map.name = "cp_base_name_b1"
      expect(map.version).to eql("b1")
    end
    it "matches final" do
      map.name = "cp_base_name_final"
      expect(map.version).to eql("final")
    end
    it "ignores non version names" do
      map.name = "cp_base_name"
      expect(map.version).to be_nil
    end
    it "catches numbers at the end of the name" do
      map.name = "cp_base_name2"
      expect(map.version).to eql("2")
    end
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

  describe "#base_map_name_and_type" do
    its(:base_map_name_and_type) { should eql "cp_base_name"}
  end

  describe "#other_versions" do
    subject{ map.other_versions.map(&:name)}
    before do
      FactoryGirl.create(:map, name: "koth_base_name_v1")
      FactoryGirl.create(:map, name: "cp_base_name")
      FactoryGirl.create(:map, name: "cp_base_name_v2")
      FactoryGirl.create(:map, name: "cp_base_name_final")
      FactoryGirl.create(:map, name: "cp_dustbowl")
      FactoryGirl.create(:map, name: "koth_place_v1")
      FactoryGirl.create(:map, name: "cp_secret_base_b1")
    end

    it { should match_array(["cp_base_name", "cp_base_name_v2", "cp_base_name_final"])}
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
    #pending { should_not include( "cp_secret_base_b1") }

  end

  describe "#to_param" do
    subject {map.to_param}
    it { should eql(map.name.parameterize)}
  end

  describe "#should_play_next_score" do
    subject {map.should_play_next_score}
    before do
      map.last_played_at = "Fri, 25 May 2012 11:37:45 UTC +00:00"
      map.likes_count = 3
      map.hates_count = 0
      map.save!

      @time_now = Time.parse("2013-12-13 11:57:04 -0500")
      Time.stub!(:now).and_return(@time_now)
    end

    it { should be_close(0.23691896787177671, 0.00001)}
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
