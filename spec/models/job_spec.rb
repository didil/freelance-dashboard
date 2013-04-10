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
    Job.should_receive(:update_odesk_jobs)
    Job.update_jobs "php"
  end

  it 'updates odesk jobs by keyword' do
    1.upto(5) do |i|
      FactoryGirl.create(:job, :title => "Job #{i}")
    end

    jobs = []
    1.upto(10) do |i|
      job = double("job")
      job.stub(:op_title).and_return("Job #{i}")
      job.stub(:op_description).and_return("Job description #{i}")
      job.stub(:op_required_skills).and_return("Php,html,js")
      job.stub(:ciphertext).and_return("~~cypher123")
      jobs << job
    end

    RubyDesk::Connector.should_receive(:new).and_return(nil)
    RubyDesk::Job.should_receive(:search).and_return(jobs)

    expect { Job.update_odesk_jobs("php") }.to change(Job, :count).from(5).to(10)

    my_job = Job.last

    my_job.title.should =~ /Job \d/
    my_job.description.should =~ /Job description \d/
    my_job.keywords.should == "php,html,js"

  end

end
