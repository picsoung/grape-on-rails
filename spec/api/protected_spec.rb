require 'spec_helper'

describe Acme::Protected do
  context "without authorization" do
    it "ping" do
      get "/api/protected/ping"
      response.status.should == 401
      response.body.should == ""
    end
  end
  context "with incorrect authorization" do
    it "ping" do
      get "/api/protected/ping", nil, {
        "HTTP_AUTHORIZATION" => ActionController::HttpAuthentication::Basic.encode_credentials("foo", "bar")
      }
      response.status.should == 401
      response.body.should == ""
    end
  end
  context "with authorization" do
    it "ping" do
      get "/api/protected/ping", nil, {
        "HTTP_AUTHORIZATION" => ActionController::HttpAuthentication::Basic.encode_credentials("username", "password")
      }
      response.status.should == 200
      response.body.should == { :ping => "pong" }.to_json
    end
  end
end

