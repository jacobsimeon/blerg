require "sinatra"
require "simple_oauth"
require "json"
require "tweeter"

module FakeTwitter
  class Tweets
    def self.all
      @tweets ||= []
    end

    def self.add(tweet)
      self.all << tweet["status"]
    end

    def self.clear
      @tweets = []
    end
  end

  class Server < Sinatra::Application
    post "/1.1/statuses/update.json" do
      status = URI.decode_www_form(request.body.read).to_h
      oauth_params = SimpleOAuth::Header.parse(request.env["HTTP_AUTHORIZATION"])
      secrets = {
        consumer_secret: Tweeter::CONSUMER_SECRET,
        token_secret: Tweeter::TOKEN_SECRET
      }

      validation_header = SimpleOAuth::Header.new(
        :post,
        "http://localhost:4567/1.1/statuses/update.json",
        status,
        oauth_params
      )

      unless validation_header.valid?(secrets)
        status(:unauthorized)
        return
      end

      Tweets.add(status)

      status(:created)
    end

    get "/tweets" do
      content_type :json
      Tweets.all.to_json
    end

    put "/clear" do
      Tweets.clear
    end
  end
end
