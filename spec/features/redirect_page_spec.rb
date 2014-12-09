require "rails_helper"

feature "Set a page to redirect to another page" do

  let!(:nonredirect_page) { Page.create(title: "nonredirect", wikitext: "page without redirect") }
  let!(:target_page) { Page.create(title: "the target", wikitext: "target page contents") }
  let!(:redirector) { Page.create(title: "redirector", redirect_to: "the target") }

  scenario "redirect field is hidden on new page form, can be toggled", js: true do
    visit new_page_path
    expect(page).not_to have_selector("#redirect")
    expect(page).to have_link("Add redirect")
    click_link "Add redirect"
    expect(page).to have_selector("#redirect")
    click_link "Hide redirect"
    expect(page).not_to have_selector("#redirect")    
  end

  scenario "redirect field is hidden on edit form if empty, can be toggled", js: true do
    visit edit_page_path(nonredirect_page)
    expect(page).to have_field("Page contents", text: nonredirect_page.wikitext)
    expect(page).not_to have_selector("#redirect")
    expect(page).to have_link("Add redirect")
    click_link "Add redirect"
    expect(page).to have_selector("#redirect")
    click_link "Hide redirect"
    expect(page).not_to have_selector("#redirect")    
  end

  scenario "redirect field is shown on edit if nonempty", js: true do
    visit edit_page_path(redirector)
    expect(page).to have_selector("#redirect")
    expect(page).to have_link("Hide redirect")
  end

  scenario "create a new page with redirect" do
    visit new_page_path
    fill_in "Page title", with: "redirecting page"
    fill_in "Redirect to", with: "the target"
    click_button "Save"

    expect(page).to have_content(target_page.wikitext)
  end

  scenario "target shows the name and editlink for the redirecting page" do
    visit page_path(redirector)
    expect(page).to have_content(target_page.wikitext)
    expect(page).to have_content("Redirected from")
    expect(page).to have_link("redirector", href: edit_page_path(redirector))
  end

  scenario "after removing redirect parameter page no longer redirects" do
    visit edit_page_path(redirector)
    fill_in "Redirect to", with: ""
    fill_in "Page contents", with: "no longer redirecting"
    click_button "Save"

    expect(page).to have_content("no longer redirecting")
  end

end
