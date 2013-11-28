require "spec_helper"

feature "Create a New Page" do

  before do
    visit root_url
    click_link "Create a new page"
  end

  scenario "display new page form" do
    expect(page).to have_content("New page")
    expect(page).to have_field("Page title", with: "")
    expect(page).to have_field("Page contents", with: "")
  end

  scenario "saving and showing new page contents" do
    fill_in "Page title", with: "new page title"
    fill_in "Page contents", with: "text for the new page"
    click_button "Save"
    expect(page).to have_title("new page title")
    expect(page).to have_content("new page title")
    expect(page).to have_content("text for the new page")
  end

  scenario "return to form and show error when title missing" do
    click_button "Save"
    expect(page).to have_content("Cannot save with empty title")
  end

  scenario "return to form and show error when title already taken" do
    Page.create(title: "NewPageTitle")
    fill_in "Page title", with: "new page title"
    fill_in "Page contents", with: "new page contents"
    click_button "Save"
    expect(page).to have_content("page with that title already exists")
  end

  scenario "when trying to save with existing title, link to the existing page" do
    prev = Page.create(title: "NewPageTitle")
    fill_in "Page title", with: "new page title"
    fill_in "Page contents", with: "new page contents"
    click_button "Save"
    expect(page).to have_link("edit the existing page", href: edit_page_path(prev))
  end

  scenario "save and edit stores the current text and returns to editing" do
    fill_in "Page title", with: "Save and edit page"
    fill_in "Page contents", with: "new text"
    click_button "Save & edit"

    expect(Page.find_by(wikititle: "SaveAndEditPage").wikitext).to eq "new text"
    expect(page).to have_content('Editing "Save and edit page"')
    expect(page).to have_field("Page contents", text: "new text")
  end

end

feature "Create a new page when visiting an non-existing page" do

  scenario "visiting nonexistent brings up new page form" do
    visit "/NonExistentPage"

    expect(page).to have_selector("h1", "New Page")
    expect(page).to have_field("Page title", with: "NonExistentPage")
    expect(page).to have_field("Page contents", with: "")
  end
end


feature "Cancelling new page" do
  scenario "cancel redirects to the home page" do
    visit new_page_path
    click_link "Cancel"

    expect(page).to have_content("VSWiki Home Page")

  end
end
