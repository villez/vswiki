require "spec_helper"

feature "Create a New Page" do

  before do
    visit root_url
    click_link "Create a new page"
  end

  scenario "new page form" do
    expect(page).to have_content("New page")
  end

  scenario "saving and showing new page contents" do
    fill_in "Page title", with: "new page title"
    fill_in "Page contents", with: "text for the new page"
    click_button "Save"
    expect(page).to have_title("NewPageTitle")
    expect(page).to have_content("new page title")
    expect(page).to have_content("text for the new page")
  end

end
