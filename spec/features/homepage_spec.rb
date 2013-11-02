require "spec_helper"

feature "Home Page" do

  before do
    visit root_url
  end

  scenario "home page heading" do
    expect(page).to have_content("VSWiki Home Page")
  end

  scenario "a link to create a new page" do
    expect(page).to have_link("Create a new page")
  end
end
