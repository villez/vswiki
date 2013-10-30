require 'spec_helper'

feature "Home Page" do
  scenario "has default home page content" do
    visit root_url
    expect(page).to have_content("VSWiki Home Page")
  end
end
