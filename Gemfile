source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem 'concurrent-ruby', '1.2.2'
ruby '3.0.3'

gem 'active_storage_validations'
gem 'aws-sdk-s3', require: false
gem 'bootsnap', '>= 1.4.2', require: false
gem 'cocoon'
gem 'devise'
gem 'devise-i18n'
gem 'devise-i18n-views'
gem 'doorkeeper'
gem 'dotenv-rails'
gem 'enum_help'
gem 'image_processing', '~> 1.12.1'
gem 'importmap-rails', '~> 1.0'
gem 'jbuilder', '~> 2.11.5'
gem 'kaminari'
gem 'lograge'
gem 'multi_json'
gem 'nokogiri', '1.12.5'
gem 'pg', '~> 1.2'
gem 'phonelib'
gem 'puma', '~> 5.5.2'
gem 'pundit'
gem 'rack-cors'
gem 'rails', '~> 7.0.1'
gem 'rails-i18n'
gem 'redis', '4.5.1'
gem 'rswag', '~> 2.5.1'
gem 'sass-rails', '~> 5'
gem 'secure_headers'
gem 'sidekiq'
gem 'sidekiq-failures'
gem 'simple_form'
gem 'slim'
gem 'turbo-rails'
gem 'twilio-ruby'

# Dry family gems
gem 'dry-initializer', '~> 3.0.0'
gem 'dry-logic', '1.2.0'
gem 'dry-monads', '~> 1.4.0'
gem 'dry-struct', '~> 1.4.0'
gem 'dry-transformer'
gem 'dry-types', '~> 1.5.0'

group :production, :staging do
end

group :development, :test do
  gem 'brakeman'
  gem 'byebug', platforms: %w[mri mingw x64_mingw]
  gem 'faker'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'pry-stack_explorer'
end
# since we need to run swaggerize command once in server (preview)
# https://github.com/rswag/rswag/issues/81#issuecomment-317534154
gem 'factory_bot_rails'
gem 'rspec'
gem 'rspec-rails', '~> 4.0.1'
gem 'shoulda-matchers'
gem 'validates_timeliness', '~> 7.0.0.beta1'

# swaggerize does not run spec just needded for documentation updates
group :development do
  gem 'letter_opener'
  gem 'listen', '3.5'
  gem 'rails-erd'
  gem 'rubocop'
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'spring', '~> 3.0.0'
  gem 'spring-commands-rspec'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'database_cleaner-active_record'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end

gem 'tzinfo-data', platforms: %w[mingw mswin x64_mingw jruby]