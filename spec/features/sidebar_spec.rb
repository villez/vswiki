require "spec_helper"

feature "Sidebar" do

  let!(:sidebar) { Page.create(title: "Sidebar", wikitext: "this is the sidebar!") }
  let!(:a_page) { Page.create(title: "some other page", wikitext: "page wikitext") }

  scenario "show sidebar on the home page" do
    visit root_url
    expect(page).to have_css("div.wiki-sidebar")
    expect(page).to have_content("this is the sidebar!")
  end

  scenario "show sidebar when viewing a wikipage" do
    visit page_path(a_page)
    expect(page).to have_content("some other page")
    expect(page).to have_css("div.wiki-sidebar")
    expect(page).to have_link("Home page")
    expect(page).to have_content("this is the sidebar!")
  end

  scenario "don't show sidebar when entering a new page" do
    visit new_page_path
    expect(page).not_to have_css("div.wiki-sidebar")
  end

  scenario "don't show sidebar when editing a page" do
    visit edit_page_path(a_page)
    expect(page).not_to have_css("div.wiki-sidebar")
  end

  scenario "edit page for the sidebar" do
    visit page_path(a_page)
    click_link "Edit sidebar"
    expect(page).to have_content('Editing "Sidebar"')
  end

  scenario "saving sidebar edits" do
    visit edit_page_path(sidebar)
    fill_in "Page content", with: "new stuff for sidebar"
    click_button "Save"
    visit page_path(a_page)

    expect(page).to have_content("new stuff for sidebar")
  end
end
