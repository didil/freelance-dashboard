require "spec_helper"

feature "list jobs" do
  let(:user) { FactoryGirl.create(:user) }

  before(:each) do
    FactoryGirl.create(:keyword, content: "php")
    FactoryGirl.create(:keyword, content: "ruby")
    @jobs = []
    @jobs << FactoryGirl.create(:job, keywords: "php")
    @jobs << FactoryGirl.create(:job, keywords: "php, cake")
    @jobs << FactoryGirl.create(:job, keywords: "ruby")
    @jobs << FactoryGirl.create(:job, keywords: "html")
    sign_in_as user
  end

  scenario "show jobs" do
    visit '/'
    within("#jobs_container") do
      page.should have_selector('li.job', :count => 3)
      page.should have_content("Job Title")
      page.should have_content("Job Description")
    end
  end

  scenario "reload jobs when keyword modified", :js => true do
    visit '/'
    within("#keywords_container") do
      click_link "ruby"
    end
    within("#jobs_container") do
      page.should have_selector('li.job', :count => 2)
    end
  end

  scenario "refresh jobs", :js => true do
    visit '/'
    within("#jobs_container") do
      page.should have_selector('li.job', :count => 3)
    end

    FactoryGirl.create(:job, keywords: "php")

    within("#jobs_container") do
      click_link "Refresh"
      page.should have_selector('li.job', :count => 4)
    end
  end
end
