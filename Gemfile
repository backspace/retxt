source 'https://rubygems.org'

ruby '1.9.3'

gem 'rails', '3.2.13'
gem 'unicorn'

gem 'mongoid', '~> 3.0.0'
gem 'mongoid-app_settings'

gem 'devise'
gem 'cancan'

gem 'twilio-ruby'

group :test do
  gem 'rspec-rails'
  gem 'mocha', require: false
  gem 'bourne'
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
end

group :development, :test do
  gem 'pry'
  gem 'pry-nav'

  gem 'localtunnel'
  gem 'foreman'
end

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  gem 'uglifier', '>= 1.0.3'

  gem 'zurb-foundation', '~> 4.0.0'
end

gem 'jquery-rails'
gem 'haml'


gem 'newrelic_rpm'
