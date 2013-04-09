require 'spec_helper'

describe Keyword do

  it "can be valid" do
    keyword = FactoryGirl.build(:keyword )
    keyword.should be_valid
  end

  it "has a content" do
    keyword = FactoryGirl.build(:keyword , content:nil)
    keyword.should_not be_valid
  end

  it "has a user id" do
    keyword = FactoryGirl.build(:keyword , user_id:nil)
    keyword.should_not be_valid
  end

  it "checks if a keyword already exists for the user" do
    keyword = FactoryGirl.build(:keyword)
    keyword.existing?.should be_false
    FactoryGirl.create(:keyword)
    keyword.existing?.should be_true
  end
end
