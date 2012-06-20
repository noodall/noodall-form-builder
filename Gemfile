source :rubygems
source "http://gems.github.com"
gemspec

gem 'rails', '3.1.3'
gem 'noodall-ui'
gem 'dragonfly', '~> 0.7.6'
gem 'defensio'
gem 'rakismet'
gem 'fastercsv'
gem 'bson_ext'

group :test do
  gem 'email_spec'
  gem 'cucumber-rails'
  gem 'rspec-rails', '>= 2.0.0.beta'
  gem 'factory_girl_rails'
  gem 'faker', '~> 0.3.1'
  gem 'capybara', '>= 0.3.9'
  gem 'database_cleaner'
  gem 'launchy'    # So you can do Then show me the page
end

if RUBY_VERSION < '1.9'
  gem 'system_timer'
  gem "ruby-debug", ">= 0.10.3"
end

