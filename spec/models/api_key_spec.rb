require 'spec_helper'

describe ApiKey do
  it "generates a random token on creation" do
    apk = ApiKey.create(name: "test")
    expect(apk.access_token).to_not be_nil
  end
end
