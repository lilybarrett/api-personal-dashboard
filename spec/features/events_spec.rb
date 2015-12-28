require "spec_helper"

feature "events", vcr: true do

  scenario "user sees today's events" do
    visit "/"
    click_link "Events"
    expect(page).to have_content("Disney On Ice")
  end
end
