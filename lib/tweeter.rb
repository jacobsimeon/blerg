require "json"
require "net/http"
require "simple_oauth"
require "uri"

class Tweeter
  CONSUMER_SECRET = "uTpnik9WVeccEp3ZHIuO13eov4HutkmQvOb55uSUPL2F8Rmo4q"
  TOKEN_SECRET = "xS6OwmRHZC2FBkw6nUuSlU1emSaokqFCeKlLkzS6znuev"

  attr_accessor :http, :oauth_header, :encoder

  def self.configure
    yield self
  end

  def self.base_uri=(base_uri)
    @base_uri = base_uri
  end

  def self.base_uri
    @base_uri
  end

  def base_uri
    self.class.base_uri
  end

  def initialize(http)
    self.http = http
    self.oauth_header = oauth_header
    self.encoder = URI::Parser.new
  end

  def tweet(content)
    uri = URI(base_uri)
    http.start(uri.host, uri.port, use_ssl: uri.scheme == "https") do |session|
      path = "/1.1/statuses/update.json"
      body = {status: content}
      header = SimpleOAuth::Header.new(
        :post,
        File.join(base_uri, path),
        body,
        oauth_options
      )

      request = Net::HTTP::Post.new(path)
      request.body = encode_body(body)
      request["Authorization"] = header.to_s

      response = session.request(request)
      Response.new(response)
    end
  end

  private

  def encode_body(body)
    body.map { |k,v| [escape(k), escape(v)].join("=")}.join("&")
  end

  def escape(val)
    SimpleOAuth::Header.escape(val)
  end

  def oauth_options
    {
      consumer_key: "CWBfHjubBF6n01UDQXHE7oFCW",
      consumer_secret: CONSUMER_SECRET,
      token: "150569754-ZwUPzvysy17MeKtZttIyoe9uSyj59xuKoT3TodFr",
      token_secret: TOKEN_SECRET
    }
  end

  class Response
    attr_accessor :response

    def initialize(response)
      self.response = response
    end

    def body
      @body ||= JSON.parse(response.body)
    end

    def status
      response.code.to_i
    end
  end
end

