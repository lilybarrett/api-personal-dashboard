require "spec_helper"

feature "weather", vcr: true do

  scenario "user sees the local temperature" do
    visit "/"
    click_link "Weather"

    expect(page).to have_content("Temp")
  end
end
