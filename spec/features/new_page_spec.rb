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
    expect(page).to have_title("NewPageTitle")
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
    expect(page).to have_content("Title is already taken")
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
