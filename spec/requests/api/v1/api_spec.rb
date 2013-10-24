require "spec_helper"

describe "POST /v1/api" do
  subject { response }

  describe "/cast_vote" do

  end

  describe "/write_message" do
    let!(:api_key) {FactoryGirl.create(:api_key)}
    context "without access_token" do
      before {post '/v1/api/write_message'}
      its(:code) { should eql("403")}
    end
    context "with invalid access_token" do
      before {post '/v1/api/write_message', {access_token: api_key.access_token}}
      its(:code) { should eql("403")}

    end

  end

  describe "/server_query" do

  end

end
