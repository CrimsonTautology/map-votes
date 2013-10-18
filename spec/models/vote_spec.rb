require 'spec_helper'

describe Vote do
  describe ".cast_vote" do
    let(:map) {FactoryGirl.create(:map)}
    let(:user) {FactoryGirl.create(:user)}

    it "creates new votes if one has not been cast" do
      Vote.delete_all
      expect{Vote.cast_vote(user, map, 1)}.to change{Vote.count}.from(0).to(1)
    end

    it "changes an already cast vote for the same map by the same user" do
      Vote.cast_vote user, map, -1
      expect{Vote.cast_vote(user, map, 1)}.to_not change{Vote.count}
      expect( Vote.find_by_user_id_and_map_id(user, map).value ).to eq(1)

    end

    it "rejects invalid votes" do
      expect{Vote.cast_vote(user, map, 722134)}.to_not change{Vote.count}
    end

  end
end
