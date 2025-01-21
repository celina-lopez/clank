source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.read('.ruby-version').strip

gem 'bootsnap', '>= 1.4.2', require: false # Reduces boot times through caching; required in config/boot.rb
gem 'jbuilder', '~> 2.7' # Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.6' # Use Puma as the app server
gem 'rails', '~> 7.0.0'
gem 'redis'
gem 'sass-rails', '>= 6' # Use SCSS for stylesheets
gem 'turbolinks', '~> 5' # Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# 3rd party gems
gem 'bootstrap', '~> 5.3.2'
gem 'font-awesome-sass'
gem 'importmap-rails', '~> 2.0'
gem 'light-service'
gem 'tailwindcss-rails', '~> 2.3'
gem 'toastr-rails', '~> 1.0'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot', '~> 6.2'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'pry'
  gem 'rspec-rails', '~> 6.0.3'
  gem 'shoulda-matchers'
end

group :development do
  gem 'annotate', '~> 3.2.0'
  gem 'listen', '~> 3.2' # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'rubocop'
  gem 'spring' # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring-watcher-listen'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

gem "uglifier", "~> 4.2"
