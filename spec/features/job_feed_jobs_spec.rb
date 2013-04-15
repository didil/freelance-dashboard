require "spec_helper"

describe "list jobs" do
  let(:user) { FactoryGirl.create(:user) }

  before(:each) do
    FactoryGirl.create(:keyword, content: "php" , user_id:user.id)

    FactoryGirl.create(:keyword, content: "ruby", user_id:user.id)

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

  it "show jobs" do
    visit '/'
    within("#jobs_container") do
      page.should have_selector('li.job', :count => 3)
      page.should have_content("Job Title")
      page.should have_content("Job Description")
    end
  end

  it "reload jobs when keyword modified", :js => true do
    visit '/'
    within("#keywords_container") do
     find("#ruby").click
    end
    within("#jobs_container") do
      page.should have_selector('li.job', :count => 2)
    end
  end

  it "refresh jobs", :js => true do
    visit '/'
    within("#jobs_container") do
      page.should have_selector('li.job', :count => 3)
    end


    FactoryGirl.create(:keyword, content: "html")

    within("#jobs_container") do
      click_link "Refresh"
      page.should have_selector('li.job', :count => 4)
      page.should have_content("4 jobs")
    end
  end

  it "show number of jobs filtered" do
    visit '/'
    within("#jobs_container") do
      page.should have_content "3 jobs"
    end
  end

  it "Read more link in description", :js => true do
    visit '/'
    within(:xpath, "//ul[@id='jobs_list']") do
      page.should_not have_content("end")
      click_link "Read more"
      page.should have_content("end")
    end
  end

end
