source 'https://rubygems.org'

gem "rest-client"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.4.0'
gem 'devise'
gem 'whenever', require: false
gem 'omniauth-google-oauth2'
gem 'omniauth-facebook'
gem 'gon'
gem 'carrierwave'
gem 'fog'
gem 'streamio-ffmpeg'
gem 'httparty'
gem 'rack-attack'
gem 'webpacker', '~> 4.0.0'
gem 'faraday'
gem 'kaminari'
gem 'kaminari-bootstrap'
gem 'nokogiri'

#gem 'omniauth'
#gem 'omniauth-twitter'
#gem 'omniauth-facebook'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.2'
# Use sqlite3 as the database for Active Record
gem 'rinku'
# Use Puma as the app server
gem 'puma', '~> 3.11'
gem "aws-sdk-s3", require: false
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby
gem "rspec", ">= 3.0.0"
gem 'rack-cors'
gem 'bcrypt'
gem 'jquery-rails'
gem 'jquery-turbolinks'
gem 'bootstrap-sass'
gem 'carrierwave'
gem 'sqlite3', group: [:development, :test]
gem 'gon'
gem 'dropzonejs-rails'
gem 'google-cloud-translate'
gem 'autosize', '~> 2.4'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

gem 'omniauth-google-oauth2'
group :production do
  gem 'pg'
end
group :development, :test do
  gem 'dotenv-rails'
end
group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'sqlite3'
  gem 'dotenv-rails'
  gem 'letter_opener_web'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
