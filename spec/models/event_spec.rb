require 'spec_helper'
describe Event do
  describe "#initialize" do
    let(:map) {FactoryGirl.create(:map)}
    let(:user) {FactoryGirl.create(:user)}
    subject {@event}

    context "Map creation event" do
      before {@event = Event.new(map)}
      its(:type) {should eql(:map)}
      its(:map) {should eql(map)}
      its(:user) {should be_nil}
      its(:count) {should eq(1)}
      it {should_not be_aggregate}
    end

    context "MapComment creation event" do
      before {@event = Event.new(FactoryGirl.create(:map_comment, map: map, user: user))}
      its(:type) {should eql(:map_comment)}
      its(:map) {should eql(map)}
      its(:user) {should eql(user)}
      its(:count) {should eq(1)}
      it {should_not be_aggregate}
    end

    context "Vote cast event" do
      before {@event = Event.new(FactoryGirl.create(:vote, map: map, user: user))}
      its(:type) {should eql(:vote)}
      its(:map) {should eql(map)}
      its(:user) {should eql(user)}
      its(:count) {should eq(1)}
      it {should_not be_aggregate}
    end

    context "Unknown event" do
      before {@event = Event.new(nil)}
      its(:type) {should eql(:unknown)}
      its(:map) {should be_nil}
      its(:user) {should be_nil}
      its(:count) {should eq(1)}
      it {should_not be_aggregate}
    end
  end

  describe "#increment" do
    before do
      @event = Event.new(FactoryGirl.create(:map_comment))
      @event.increment
    end

    subject{@event}
    its(:count) {should eq(2)}
    it {should be_aggregate}
    its(:user) {should be_nil}
    its(:map) {should_not be_nil}
  end

  describe ".build_list" do
    let(:m1) {FactoryGirl.create(:map)}
    let(:m2) {FactoryGirl.create(:map)}
    let(:u1) {FactoryGirl.create(:user)}
    let(:u2) {FactoryGirl.create(:user)}
    let(:v1) {FactoryGirl.create(:vote, user: u1, map: m1)}
    let(:v2) {FactoryGirl.create(:vote, user: u2, map: m1)}
    let(:v3) {FactoryGirl.create(:vote, user: u1, map: m2)}
    let(:v4) {FactoryGirl.create(:vote, user: u2, map: m2)}
    let(:mc1) {FactoryGirl.create(:map_comment, user: u1, map: m1)}
    let(:mc2) {FactoryGirl.create(:map_comment, user: u2, map: m1)}
    let(:mc3) {FactoryGirl.create(:map_comment, user: u1, map: m2)}
    let(:mc4) {FactoryGirl.create(:map_comment, user: u2, map: m2)}

    it "combines related maps" do
      es = Event.build_list [v1, v2]
      expect(es.first.count).to eq(2)
    end

    it "does not combine non sequential events for same map" do
      es = Event.build_list [v1, v3, v2]
      expect(es.first.count).to eq(1)
    end

    it "builds a list of events" do
      es = Event.build_list [v1, m2, v3, v4, mc3, v2, mc4, mc1, mc2]
      expect(es.length).to eq(7)
    end

  end
end

