require "rails_helper"

feature "Creating a post" do
  scenario "Creating a post with valid input" do
    visit "/"
    click_link "New Post"

    fill_in "Title", with: "A new blog post"
    fill_in "Body", with: "This is the body of the post"

    click_button "Create Post"

    expect(page).to have_content("Post was successfully created")
    expect(page).to have_content("A new blog post")
    expect(page).to have_content("This is the body of the post")
  end
end
