require "spec_helper"

feature "Wikilinks in page content" do

  let!(:first_page) { Page.create(title: "first page", wikitext: "[[second page]]") }
  let!(:second_page) { Page.create(title: "second page", wikitext: "[[first page]]") }

  scenario "render wikilink as link tag" do
    visit page_url(first_page)
    expect(page).to have_link("second page")
  end

  scenario "linking from one page to another via wikilinks" do
    visit page_url(first_page)
    click_link "second page"
    expect(page).to have_selector("h1", second_page.title)
    click_link "first page"
    expect(page).to have_selector("h1", first_page.title)
  end

end
