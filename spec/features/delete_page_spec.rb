require "spec_helper"

feature "Delete an existing page" do

  before do
    visit page_path(Page.create(title: "some page", wikitext: "old page contents"))
  end

  scenario "confirmation dialog is hidden until delete button pressed", js: true do
    # note: the have_selector matches here assume the (now default) Capybara
    # configuration ignore_hidden = true, which doesn't match non-visible elements

    # also note: condensed into a single test on purpose, because the JavaScript tests
    # are so much slower, and this is essentially a single piece of functionality
    
    expect(page).not_to have_selector("#delete-confirm")
    within "#top-controls" do
      click_button "Delete"
    end
    expect(page).to have_selector("#delete-confirm")
    within "#delete-confirm" do
      click_button "Cancel"
    end
    expect(page).not_to have_selector("#delete-confirm")
  end

  # since we test displaying the modal above, we just use it directly
  # in the subsequent tests and focus on testing the delete feature
  
  scenario "deleting the page removes it from the database" do
    expect { click_link "Yes, delete!" }.to change(Page, :count).by(-1)
  end

  scenario "deleting the page redirects to the home page" do
    within "#delete-confirm" do
      click_link "Yes, delete!"
    end
    expect(page).to have_content("VSWiki Home Page")
  end
end

