# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :jobs_request do
    keyword "MyString"
    requested_at "2013-04-11 15:13:28"
  end
end
