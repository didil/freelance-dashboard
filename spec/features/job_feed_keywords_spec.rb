require "spec_helper"

feature "manage keywords" do
  let(:user) {FactoryGirl.create(:user) }
  
  before(:each) do
    sign_in_as user
  end

  scenario "add keywords" do
    visit '/'

    expect(page).to have_content "Add a keyword to activate your job feed"

    fill_in 'keyword_content', :with => "php"
    click_button 'Add Keyword'
    fill_in 'keyword_content', :with => "php"
    click_button 'Add Keyword'

    expect(page).to have_content "Cannot add a keyword twice"

    fill_in 'keyword_content', :with => "html"
    click_button 'Add Keyword'

    within "#keywords_container" do
      page.should have_content('php')
      page.should have_content('html')
      page.should have_selector('li a', :count => 2)
    end
  end

  scenario "add keywords with js", :js => true do
    visit '/'

    expect(page).to have_content "Add a keyword to activate your job feed"

    fill_in 'keyword_content', :with => "php"
    click_button 'Add Keyword'
    fill_in 'keyword_content', :with => "php"
    click_button 'Add Keyword'

    expect(page).to have_content "Cannot add a keyword twice"

    fill_in 'keyword_content', :with => "html"
    click_button 'Add Keyword'

    within "#keywords_container" do
      page.should have_content('php')
      page.should have_content('html')
      page.should have_selector('li a', :count => 2)
    end
  end

  scenario "delete a keyword" do
    FactoryGirl.create(:keyword, :content => "php", :user_id => user.id)
    FactoryGirl.create(:keyword, :content => "ruby", :user_id => user.id)
    visit '/'
    within "#keywords_container" do
      click_link 'php'
    end
    within "#keywords_container" do
      page.should_not have_content('php')
      page.should have_content('ruby')
    end
  end

  scenario "delete a keyword with js" , :js => true do
    FactoryGirl.create(:keyword, :content => "php", :user_id => user.id)
    FactoryGirl.create(:keyword, :content => "ruby", :user_id => user.id)
    visit '/'
    within "#keywords_container" do
      click_link 'php'
    end
    within "#keywords_container" do
      page.should_not have_content('php')
      page.should have_content('ruby')
    end
  end
end

