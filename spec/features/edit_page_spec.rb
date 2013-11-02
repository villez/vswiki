require "spec_helper"

feature "Edit an existing page" do

  let!(:the_page) { Page.create(title: "some page", wikitext: "old page contents") }

  scenario "edit page contents" do
    visit edit_page_path(the_page)
    fill_in "Page content", with: "replacement text"
    click_button "Save"

    expect(page).to have_content("replacement text")
  end

end
