require "spec_helper"

feature "Edit an existing page" do

  let!(:the_page) { Page.create(title: "some page", wikitext: "old page contents") }

  before do
    visit edit_page_path(the_page)
  end

  scenario "edit page contents" do
    fill_in "Page content", with: "replacement text"
    click_button "Save"

    expect(page).to have_content("replacement text")
  end

  scenario "show error when trying to save without title" do
    fill_in "Page title", with: ""
    click_button "Save"

    expect(page).to have_content("Cannot save with empty title")
  end

end
