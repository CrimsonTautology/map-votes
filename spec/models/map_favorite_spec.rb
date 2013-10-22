require 'spec_helper'

describe MapFavorite do
  let(:map) {FactoryGirl.create(:map)}
  let(:user) {FactoryGirl.create(:user)}

  describe ".favorite" do
    it "adds a favorite if there is none for this user and map" do
      expect{MapFavorite.favorite(user, map)}.to change{MapFavorite.count}.from(0).to(1)
    end

    it "does not add multiple favorites for the same map/user" do
      MapFavorite.favorite(user, map)
      expect{MapFavorite.favorite(user, map)}.not_to change{MapFavorite.count}.by(1)
    end
  end

  describe ".unfavorite" do
    it "removes a favorite if one exists" do
      MapFavorite.favorite(user, map)
      expect{MapFavorite.unfavorite(user, map)}.to change{MapFavorite.count}.from(1).to(0)
    end

  end
end
