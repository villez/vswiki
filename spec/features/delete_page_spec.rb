require "spec_helper"

feature "Delete an existing page" do
  let!(:the_page) { Page.create(title: "some page", wikitext: "old page contents") }

  before do
    visit page_path(the_page)
  end

  scenario "delete the page using top button" do
    within ".show-page-controls-top" do
      click_link "Delete page"
    end

    expect(page).to have_content("VSWiki Home Page")
  end

  scenario "delete the page using bottom button" do
    within ".show-page-controls-bottom" do
      click_link "Delete page"
    end

    expect(page).to have_content("VSWiki Home Page")
  end
end
