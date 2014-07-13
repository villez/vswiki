require "spec_helper"

feature "Wikilinks in page content" do

  let!(:first_page) { Page.create(title: "first page", wikitext: "[[second page]]") }
  let!(:second_page) { Page.create(title: "second page", wikitext: "[[first page]]") }
  let!(:page_linking_to_nonexistent) { Page.create(title: "page linking to nonexistent",
                                                   wikitext: "[[nonexistent page]]") }

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

  scenario "special class in the wikilink if the linked wikipage doesn't exist" do
    visit page_url(page_linking_to_nonexistent)
    expect(page).to have_css("a.wikinoexist", text: "nonexistent page")
    # the link to second page should not have the class as that page exist
    expect(page).not_to have_css("a.wikinoexist", text: "second page")
  end
end
