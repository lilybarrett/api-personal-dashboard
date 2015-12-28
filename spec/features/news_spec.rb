require "spec_helper"

feature "news", vcr: true do

  scenario "user sees the latest news headlines" do
    visit "/"
    click_link "News"
    expect(page).to have_content("A Surgery Center That Doubles as an Idea Lab")
  end
end
