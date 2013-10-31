require 'spec_helper'

describe User do
  let(:user) {FactoryGirl.create(:user)}

  its(:to_param){ should eql(user.uid)}
end
