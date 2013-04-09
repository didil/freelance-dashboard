# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :job do
    title "Job Title"
    description "Job Description"
    keywords "keyword1 , keyword2"
    platform "Odesk"
  end
end
