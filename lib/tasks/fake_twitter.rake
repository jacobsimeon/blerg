require "fake_twitter"

namespace :fake_twitter do
  task :start do
    FakeTwitter::Server.run!
  end
end
