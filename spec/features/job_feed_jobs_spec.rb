require "spec_helper"

feature "list jobs" do
  let(:user) { FactoryGirl.create(:user) }

  before(:each) do
    FactoryGirl.create(:keyword, content: "php")
    FactoryGirl.create(:keyword, content: "ruby")

    # avoid fetching jobs
    JobsRequest.create(keyword: "php", requested_at: Time.now)
    JobsRequest.create(keyword: "ruby", requested_at: Time.now)
    JobsRequest.create(keyword: "html", requested_at: Time.now)

    @jobs = []
    @jobs << FactoryGirl.create(:job, keywords: "php")
    @jobs << FactoryGirl.create(:job, keywords: "php, cake", description: ("bla " * 100) + "end")
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

    FactoryGirl.create(:job, keywords: "html")

    within("#jobs_container") do
      click_link "Refresh"
      page.should have_selector('li.job', :count => 4)
      page.should have_content("4 jobs")
    end
  end

  scenario "show number of jobs filtered" do
    visit '/'
    within("#jobs_container") do
      page.should have_content "3 jobs"
    end
  end

  scenario "Read more link in description", :js => true do
    visit '/'
    within(:xpath, "//ul[@id='jobs_list']") do
      page.should_not have_content("end")
      click_link "Read more"
      page.should have_content("end")
    end
  end

end
