require 'spec_helper'

describe User do
  let!(:user) {FactoryGirl.create(:user, uid: "239319123")}
  subject{ user }

  its(:to_param){ should eql(user.uid)}
end
