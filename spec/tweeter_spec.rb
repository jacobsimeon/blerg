require "spec_helper"
require "net/http"
require "simple_oauth"
require "tweeter"

describe Tweeter do
  describe "tweet" do
    it "executes a request witht the correct body and headers" do
      net_http = double(:net_http)
      session = double(:session)

      expect(net_http).to(
        receive(:start).with("example.com", 80, use_ssl: true).and_yield(session)
      )

      request = nil
      expect(session).to(
        receive(:request).with(instance_of(Net::HTTP::Post)) { |r|
          request = r
          double(:response, code: "200", body: {some: :json}.to_json)
        }
      )

      tweeter = Tweeter.new("http://example.com", net_http)
      response = tweeter.tweet("Hello world")

      oauth_attrs = SimpleOAuth::Header.parse(request["Authorization"])
      header = SimpleOAuth::Header.new(
        :post,
        "http://example.com/1.1/statuses/update.json",
        {status: "Hello world"},
        oauth_attrs
      )

      secrets = {
        consumer_secret: Tweeter::CONSUMER_SECRET,
        token_secret: Tweeter::TOKEN_SECRET
      }

      expect(header.valid?(secrets)).to(be(true))
      expect(request.path).to(eq("/1.1/statuses/update.json"))
      expect(request.body).to(eq("status=Hello%20world"))
      expect(response.body).to(eq({"some" => "json"}))
      expect(response.status).to(eq(200))
    end
  end
end
