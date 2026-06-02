source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'

gem 'rails', '~> 6.1.7', '>= 6.1.7.8'
gem 'pg', '~> 1.3.0'
gem 'puma', '~> 5.0'
gem 'bcrypt', '~> 3.1.7'
gem 'bootsnap', '>= 1.4.4', require: false
gem 'rack-cors'
gem 'kaminari'
gem 'jbuilder', '~> 2.11'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails', '~> 5.0'
  gem 'factory_bot_rails', '~> 6.2.0'
  gem 'faker'
end

group :development do
  gem 'listen', '~> 3.3'
  gem 'spring'
  gem 'spring-commands-rspec'
end

group :test do
  gem 'shoulda-matchers', '~> 5.0'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'ffi', '~> 1.15.5'
