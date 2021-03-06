require 'spec_helper'

describe User do

  before(:each) do
    @attr = {
        :name => "Example User",
        :email => "user@example.com",
        :password => "changeme",
        :password_confirmation => "changeme"
    }
  end

  it "should create a new instance given a valid attribute" do
    User.create!(@attr)
  end

  it "should require an email address" do
    no_email_user = User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end

  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end

  it "should reject invalid email addresses" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end

  it "should reject duplicate email addresses" do
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  it "should reject email addresses identical up to case" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  describe "passwords" do

    before(:each) do
      @user = User.new(@attr)
    end

    it "should have a password attribute" do
      @user.should respond_to(:password)
    end

    it "should have a password confirmation attribute" do
      @user.should respond_to(:password_confirmation)
    end
  end

  describe "password validations" do

    it "should require a password" do
      User.new(@attr.merge(:password => "", :password_confirmation => "")).
          should_not be_valid
    end

    it "should require a matching password confirmation" do
      User.new(@attr.merge(:password_confirmation => "invalid")).
          should_not be_valid
    end

    it "should reject short passwords" do
      short = "a" * 5
      hash = @attr.merge(:password => short, :password_confirmation => short)
      User.new(hash).should_not be_valid
    end

  end

  describe "password encryption" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end

    it "should set the encrypted password attribute" do
      @user.encrypted_password.should_not be_blank
    end

  end
end

describe "User#jobs" do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @keyword_1 = FactoryGirl.create(:keyword, content: "php", user_id: @user.id)
    @keyword_2 = FactoryGirl.create(:keyword, content: "html", user_id: @user.id)
    @keyword_1.stub(:outdated?).and_return(false)
    @keyword_2.stub(:outdated?).and_return(false)
    @user.should_receive(:keywords).twice.and_return [@keyword_1, @keyword_2]
    FactoryGirl.create(:job, keywords: "php", id: 10)
    FactoryGirl.create(:job, keywords: "php, cake", id: 20)
    FactoryGirl.create(:job, keywords: "html", id: 30)
    FactoryGirl.create(:job, keywords: "translation", id: 4)
  end

  it "should retrieve jobs" do
    @user.jobs.length.should eq(3)
  end

  it "should retrieve jobs after" do
    @user.jobs(id: 17).length.should eq(2)
  end

  it "should update jobs if keyword outdated" do
    @keyword_1.stub(:outdated?).and_return(true)
    Job.should_receive(:update_jobs).with("php")
    @user.jobs
  end

  it "should skip updates when told so" do
    @keyword_1.stub(:outdated?).and_return(true)
    @keyword_2.stub(:outdated?).and_return(true)
    Job.should_not_receive(:update_jobs)
    @user.jobs :skip_updates => true
  end

end


