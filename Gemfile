source 'https://rubygems.org'
ruby '2.0.0'
gem 'rails', '4.1.1'
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0',          group: :doc
gem 'spring',        group: :development
gem 'bootstrap-sass'
gem 'figaro', :github=>"laserlemon/figaro"
gem 'haml-rails'
gem 'simple_form'
gem 'pg'
gem 'newrelic_rpm'
gem 'carrierwave'
gem "fog", "~> 1.3.1"
gem "mini_magick"
gem "exifr"
gem "mail"
gem "geocoder"
gem "delayed_job_active_record"
gem "delayed_job_web"
gem 'rack-cors',
  :require => 'rack/cors'
gem 'devise'


group :production, :staging do
  gem 'rails_12factor'
end

group :development do      
  gem 'sqlite3' 
  gem 'better_errors'
  gem 'binding_of_caller', :platforms=>[:mri_20]
  gem 'guard-bundler'
  gem 'guard-rails'
  gem 'guard-rspec'
  gem 'html2haml'
  gem 'quiet_assets'
  gem 'rails_layout'
  gem 'rb-fchange', :require=>false
  gem 'rb-fsevent', :require=>false
  gem 'rb-inotify', :require=>false
end
group :development, :test do
  gem 'factory_girl_rails'
  gem 'pry-rails'
  gem 'pry-rescue'
  gem 'rspec-rails', '>= 3.0.0.beta2'
end
group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'faker'
  gem 'launchy'
  gem 'selenium-webdriver'
end
