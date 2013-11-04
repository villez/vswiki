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


  scenario "return to form and show error when renaming to a title already in use" do
    Page.create(title: "ExistingPageTitle")
    fill_in "Page title", with: "ExistingPageTitle"
    fill_in "Page contents", with: "contents"
    click_button "Save"
    expect(page).to have_content("Title is already taken")
  end

end
