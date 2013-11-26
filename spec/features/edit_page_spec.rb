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

  scenario "cancelling edit shows the original page" do
    fill_in "Page contents", with: "some new stuff"
    click_link "Cancel"

    expect(page).to have_content("old page contents")
  end

  scenario "save and edit stores the current text and returns to editing" do
    fill_in "Page contents", with: "new text"
    click_button "Save & edit"

    expect(Page.find_by(wikititle: "SomePage").wikitext).to eq "new text"
    expect(page).to have_content("Editing")
    expect(page).to have_field("Page contents", text: "new text")
  end

end
