require "spec_helper"

feature "Set a page to redirect to another page" do

  let!(:target_page) { Page.create(title: "the target", wikitext: "target page contents") }
  let!(:redirector) { Page.create(title: "redirector", redirect_to: "the target") }

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
