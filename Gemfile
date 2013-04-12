source 'https://rubygems.org'
gem 'rails', '3.2.13'

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'
gem "bootstrap-sass", ">= 2.3.0.0"
gem "devise", ">= 2.2.3"
gem "cancan", ">= 1.6.9"
gem "rolify", ">= 3.2.0"
gem "simple_form", ">= 2.1.0"
gem "figaro", ">= 0.6.3"
gem 'ruby_desk' , :github => "Judis/ruby_desk"
gem 'nokogiri'

gem "rspec-rails", ">= 2.12.2", :group => [:development, :test]
gem "factory_girl_rails", ">= 4.2.0", :group => [:development, :test]

group  :development do
  gem "better_errors", ">= 0.7.2"
  gem "quiet_assets", ">= 1.0.2"
  gem "binding_of_caller", ">= 0.7.1", :platforms => [:mri_19, :rbx]
end

group :test do
  gem "poltergeist"
  gem 'sqlite3'
  gem "capybara", ">= 2.0.3"
  gem "database_cleaner",  '~> 0.9.1'
  gem "email_spec", ">= 1.4.0"
end

group :production do
  gem 'pg'
  gem "unicorn", ">= 4.3.1"
  gem 'newrelic_rpm'
end