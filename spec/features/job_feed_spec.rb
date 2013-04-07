require "spec_helper"

feature "user adds keyword to job feed" do
  let(:user) { FactoryGirl.create(:user) }

  scenario "when logging in for the first time" do
    visit '/'
    sign_in_as user
    expect(page).to have_content "Add a keyword to activate your job feed"
    fill_in 'keyword_content', :with => "php"
    click_button 'Add Keyword'
    expect(page).to have_content "Keyword php added successfully"
  end

  scenario "with the keyword already existing" do
    FactoryGirl.create(:keyword, content: "php", user_id: user.id)
    visit '/'
    sign_in_as user
    expect(page).not_to have_content "Add a keyword to activate your job feed"
    fill_in 'keyword_content', :with => "php"
    click_button 'Add Keyword'
    expect(page).to have_content "Cannot add a keyword twice"
  end

end