require "spec_helper"

feature "admin functions" do
  let(:user) do
    user = FactoryGirl.create(:user)
    user.add_role :admin
    user
  end

  before(:each) do
    FactoryGirl.create(:keyword)
  end

  scenario "update jobs", :js => true do
    sign_in_as user
    visit '/'
    click_link 'Update Jobs'

    within("#flash") do
      page.should have_content("Jobs updated")
    end
  end
end