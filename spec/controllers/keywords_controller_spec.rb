require 'spec_helper'

describe KeywordsController do

  before(:each) do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  describe "POST create" do
    it "creates a keyword" do
      keyword_attributes = FactoryGirl.attributes_for(:keyword, user_id: @user.id)

      expect { post 'create', :keyword => keyword_attributes }.to change(Keyword, :count).by(1)

      response.should be_redirect
      Keyword.last.content.should eq(keyword_attributes[:content])
      Keyword.last.user.should eq(@user)
    end
  end

end
