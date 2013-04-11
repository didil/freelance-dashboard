require 'spec_helper'

describe Job do

  it "saves new jobs only" do
    FactoryGirl.create(:job, :title => "Job 1")
    FactoryGirl.create(:job, :title => "Job 2")

    jobs =[]
    jobs << FactoryGirl.build(:job, :title => "Job 1")
    jobs << FactoryGirl.build(:job, :title => "Job 3")

    expect { Job.save_new_jobs(jobs) }.to change(Job, :count).from(2).to(3)
  end

  it "updates all jobs" do
    FactoryGirl.create(:keyword, content: "php")
    FactoryGirl.create(:keyword, content: "ruby")

    Job.should_receive(:update_jobs).with("php").once
    Job.should_receive(:update_jobs).with("ruby").once

    Job.update_all_jobs
  end

  it "updates jobs by keyword" do
    Job.should_receive(:fetch_odesk_jobs).with "php"
    Job.should_receive(:fetch_elance_jobs).with "php"
    Job.should_receive(:save_new_jobs).twice

    keyword = "php"
    Job.update_jobs(keyword)

    JobsRequest.find_by_keyword(keyword).requested_at.should >= 5.seconds.ago
  end

  describe "::fetch_odesk_jobs" do
    it 'fetches odesk jobs by keyword' do

      jobs = []
      1.upto(10) do |i|
        job = double("job")
        job.stub(:op_title).and_return("Job #{i}")
        job.stub(:op_description).and_return("Job description #{i}")
        job.stub(:op_required_skills).and_return("Php,html,js")
        job.stub(:ciphertext).and_return("~~cypher123")
        job.stub(:date_posted).and_return("~~cypher123")
        jobs << job
      end

      RubyDesk::Connector.should_receive(:new).and_return(nil)
      RubyDesk::Job.should_receive(:search).and_return(jobs)

      fetched_jobs = Job.fetch_odesk_jobs("php")
      fetched_jobs.length.should eq(10)

      my_job = fetched_jobs.last

      my_job.title.should =~ /Job \d/
      my_job.description.should =~ /Job description \d/
      my_job.keywords.should == "php,html,js"
      my_job.platform.should == "oDesk"
    end
  end

  describe "::fetch_elance_jobs" do
    it 'fetches elance jobs by keyword' do

      Job.should_receive(:open).and_return(open(File.expand_path("../../data/elance.html", __FILE__)))

      fetched_jobs= Job.fetch_elance_jobs("php")
      fetched_jobs.length.should eq(25)

      my_job = fetched_jobs.first

      my_job.title.should eq "Web design & programming (E-commerce)"
      my_job.description.should =~ /Stock taking control panel & Shipping services/
      my_job.keywords.should == "css, html, php"
      my_job.platform.should == "Elance"
    end
  end


end
