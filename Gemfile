source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.0'
gem 'pry'
#gem 'bootstrap-sass', git: 'https://github.com/thomas-mcdonald/bootstrap-sass.git', branch: 'master'
gem 'kaminari', '~> 0.16.1'

gem 'instagram'
gem 'google_places'
gem 'geocoder'
gem 'omniauth-facebook'
gem 'newrelic_rpm'

gem "therubyracer", '0.12.1'
gem "less-rails", '2.6.0' #Sprockets (what Rails 3.1 uses for its asset pipeline) supports LESS
gem "twitter-bootstrap-rails", '3.2.0'
gem 'haml-rails', '0.6.0'
gem 'annotate', '2.6.5'

# Use sqlite3 as the database for Active Record
group :development, :test do
  gem 'sqlite3'
  gem 'rspec-rails', '3.1.0'
  gem 'database_cleaner'
end

group :production do
  gem 'pg', '0.15.1'
  gem 'rails_12factor', '0.0.2'
end

group :test do
  gem 'factory_girl_rails'
  # gem 'guard-rspec'
  # gem 'selenium-webdriver', '2.35.1'
  gem 'capybara', '2.4.4'
end

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

