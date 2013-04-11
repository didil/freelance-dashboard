require 'spec_helper'

describe Keyword do

  it "can be valid" do
    keyword = FactoryGirl.build(:keyword)
    keyword.should be_valid
  end

  it "has a content" do
    keyword = FactoryGirl.build(:keyword, content: nil)
    keyword.should_not be_valid
  end

  it "has a user id" do
    keyword = FactoryGirl.build(:keyword, user_id: nil)
    keyword.should_not be_valid
  end

  it "checks if a keyword already exists for the user" do
    keyword = FactoryGirl.build(:keyword)
    keyword.existing?.should be_false
    FactoryGirl.create(:keyword)
    keyword.existing?.should be_true
  end

  it "checks if a keyword is outdated" do
    keyword= FactoryGirl.create(:keyword, content: "php")
    FactoryGirl.create(:jobs_request, keyword: "php", requested_at: 20.minutes.ago)
    keyword.outdated?.should be_true
  end

  it "checks if a keyword is not outdated" do
    keyword=FactoryGirl.create(:keyword, content: "php")
    FactoryGirl.create(:jobs_request, keyword: "php", requested_at: 5.minutes.ago)
    keyword.outdated?.should be_false
  end
end
