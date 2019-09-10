require "rails_helper"

describe PostsController do
  describe "create" do
    let(:fake_tweeter) { double(:fake_tweeter) }

    before do
      allow(fake_tweeter).to(receive(:tweet))
      controller.instance_variable_set(:@tweeter, fake_tweeter)
    end

    def create_post
      post :create, params: {post: {title: "Hello", body: "World"}}
    end

    it "creates a new post" do
      expect { create_post }.to change(Post, :count).by(1)
      expect(response).to redirect_to(post_path(Post.first))
    end

    it "tweets out a link to the post" do
      tweet = nil
      expect(fake_tweeter).to(receive(:tweet) { |t| tweet = t })

      create_post

      expect(tweet).to(eq("Hello #{post_url(Post.last)}"))
    end
  end
end
