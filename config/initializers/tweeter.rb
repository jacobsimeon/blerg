require "tweeter"

Tweeter.configure do |tweeter|
  if Rails.env.test?
    tweeter.base_uri = "http://localhost:4567"
  else
    tweeter.base_uri = "https://api.twitter.com"
  end
end
