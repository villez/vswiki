require "rails_helper"

RSpec.feature "Wikilinks in page content" do

  let!(:first_page) { Page.create(title: "first page", wikitext: "[[second page]]") }
  let!(:second_page) { Page.create(title: "second page", wikitext: "[[first page]]") }

  scenario "render wikilink as link tag" do
    visit page_url(first_page)
    expect(page).to have_link("second page")
  end

  scenario "linking from one page to another via wikilinks" do
    visit page_url(first_page)
    click_link "second page"
    expect(page).to have_css("h1", text: second_page.title)
    click_link "first page"
    expect(page).to have_css("h1", text: first_page.title)
  end

  scenario "special CSS class for wikilinks to nonexisting pages" do
    Page.create(title: "Existent Page", wikitext: "foo bar")
    visit page_url(Page.create(title: "LinkTest", wikitext: "[[Existent Page]] [[Nonexistent Page]]"))
    expect(page).to have_link("Nonexistent")
    expect(page).to have_link("Existent Page")
    expect(page).to have_css("a.wikinoexist", text: "Nonexistent Page")
    expect(page).not_to have_css("a.wikinoexist", text: "Existent Page")
  end
end
