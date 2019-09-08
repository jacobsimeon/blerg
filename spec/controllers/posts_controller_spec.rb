require "rails_helper"

describe PostsController do
  describe "create" do
    it "creates a new post" do
      expect {
        post :create, params: {post: {title: "Hello", body: "World"}}
      }.to change(Post, :count).by(1)

      expect(response).to redirect_to(post_path(Post.first))
    end
  end
end
