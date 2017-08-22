source 'https://rubygems.org'

gem 'rails', '4.0.2'
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'therubyracer', platforms: :ruby
gem 'jquery-rails', '~> 3.1.0'
gem 'turbolinks', '~> 2.2.1'
gem "rake", '~> 10.1.1'
gem "will_paginate", '~> 3.0.5'
gem "safe_yaml", '~> 1.0.1'
gem "jquery-ui-rails", '~> 4.2.0'
gem "nilify_blanks", '~> 1.0.3'
gem "highrise", '~> 3.1.5'
gem "mail", '~> 2.5.4'
gem "omniauth-google-oauth2", '~> 0.2.2'
gem "edn", '~> 1.0.2'
gem "httparty", '~> 0.13.0'
gem "american_date"
gem 'pg'
gem 'rails-observers', '0.1.2'
gem 'rack-attack'

gem 'warehouse', git: 'https://github.com/ryanzverner/stockroom-ruby-client.git'

group :doc do
  gem 'sdoc', require: false
end

group :test, :development do
  gem "test-unit"
  gem "rspec-rails", '~> 2.14.1'
  gem "teaspoon"
  gem "teaspoon-jasmine"
  gem "awesome_print"
  gem "pry"
  gem "pry-nav"
  gem "better_errors", '1.1.0'
end

group :test do
  gem 'database_cleaner'
  gem 'simplecov', :require => false
end

group :development, :test, :staging do
  gem 'factory_girl_rails', "~> 4.0"
  gem "faker"
end

group :production do
  gem 'unicorn', '~> 4.8.2'
end

