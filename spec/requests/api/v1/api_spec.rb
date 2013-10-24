require "spec_helper"

describe "POST /v1/api" do
  subject { response }

  describe "/cast_vote" do
    let!(:user) {FactoryGirl.create(:user, provider: "steam", uid: "123456")}
    let!(:map) {FactoryGirl.create(:map)}

    context "without access_token" do
      before {post '/v1/api/cast_vote'}
      its(:code) { should eql("403")}
    end
    context "with invalid access_token" do
      before do
        ApiKey.delete_all
        post '/v1/api/cast_vote',
          access_token: "badtoken",
          uid: user.uid,
          map: map.name,
          value: 1
      end
      its(:code) { should eql("403")}
    end

    context "with valid access_token" do
      let!(:api_key) {FactoryGirl.create(:api_key)}

      it "won't submit without a map" do
        expect do
          post '/v1/api/cast_vote',
            access_token: api_key.access_token,
            uid: user.uid,
            value: 1
        end.to_not change{Vote.count}.by(1)
      end
      it "won't submit without a user id" do
        expect do
          post '/v1/api/cast_vote',
            access_token: api_key.access_token,
            map: map.name,
            value: 1
        end.to_not change{Vote.count}.by(1)
      end
      it "won't submit without a value" do
        expect do
          post '/v1/api/cast_vote',
            access_token: api_key.access_token,
            uid: user.uid,
            map: map.name
        end.to_not change{Vote.count}.by(1)
      end

      it "Submits with needed information" do
        expect do
          post '/v1/api/cast_vote',
            access_token: api_key.access_token,
            uid: user.uid,
            map: map.name,
            value: 1
        end.to change{Vote.count}.by(1)
      end

      it "Adds new maps if they do not exist in the database" do
        expect do
          post '/v1/api/cast_vote',
            access_token: api_key.access_token,
            uid: user.uid,
            map: "New_Map",
            value: 1
        end.to change{Map.count}.by(1)
      end

    end

  end

  describe "/write_message" do
    let!(:user) {FactoryGirl.create(:user, provider: "steam", uid: "123456")}
    let!(:map) {FactoryGirl.create(:map)}

    context "without access_token" do
      before {post '/v1/api/write_message'}
      its(:code) { should eql("403")}
    end
    context "with invalid access_token" do
      before do
        ApiKey.delete_all
        post '/v1/api/write_message',
          access_token: "badtoken",
          uid: user.uid,
          map: map.name,
          comment: "Comment"
      end
      its(:code) { should eql("403")}
    end

    context "with valid access_token" do
      let!(:api_key) {FactoryGirl.create(:api_key)}

      it "won't submit without a map" do
        expect do
          post '/v1/api/write_message',
            access_token: api_key.access_token,
            uid: user.uid,
            comment: "Comment"
        end.to_not change{MapComment.count}.by(1)
      end
      it "won't submit without a user id" do
        expect do
          post '/v1/api/write_message',
            access_token: api_key.access_token,
            map: map.name,
            comment: "Comment"
        end.to_not change{MapComment.count}.by(1)
      end
      it "won't submit without a comment" do
        expect do
          post '/v1/api/write_message',
            access_token: api_key.access_token,
            uid: user.uid,
            map: map.name
        end.to_not change{MapComment.count}.by(1)
      end

      it "Submits with needed information" do
        expect do
          post '/v1/api/write_message',
            access_token: api_key.access_token,
            uid: user.uid,
            map: map.name,
            comment: "Comment"
        end.to change{MapComment.count}.by(1)
      end

      it "Adds new maps if they do not exist in the database" do
        expect do
          post '/v1/api/write_message',
            access_token: api_key.access_token,
            uid: user.uid,
            map: "New_Map",
            comment: "Comment"
        end.to change{Map.count}.by(1)
      end

      it "Can read and convert a base64 url safe comment" do
        post '/v1/api/write_message',
          access_token: api_key.access_token,
          uid: user.uid,
          map: map.name,
          base64: 1,
          comment: "QmFzZTY0RW5jb2RlZE1lc3NhZ2U="
        expect(MapComment.last.comment).to eql("Base64EncodedMessage")
      end

    end

  end

  describe "/server_query" do

  end

end
