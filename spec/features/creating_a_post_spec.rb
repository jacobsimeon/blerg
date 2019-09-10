require "rails_helper"
require "net/http"

feature "Creating a post" do
  before do
    uri = URI("http://localhost:4567/clear")
    Net::HTTP.start(uri.host, uri.port) do |session|
      request = Net::HTTP::Put.new("/clear")
      response = session.request(request)
    end
  end

  scenario "Creating a post with valid input" do
    visit "/"
    click_link "New Post"

    fill_in "Title", with: "A new blog post"
    fill_in "Body", with: "This is the body of the post"

    click_button "Create Post"

    expect(page).to have_content("Post was successfully created")
    expect(page).to have_content("A new blog post")
    expect(page).to have_content("This is the body of the post")

    uri = URI("http://localhost:4567/tweets")
    response = Net::HTTP.get(uri)
    tweets = JSON.parse(response)
    expect(tweets).to(include("A new blog post #{post_url(Post.last)}"))
  end
end
