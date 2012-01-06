source :rubygems
source "http://gems.github.com"
gemspec

gem 'rails', '3.1.3'
gem 'noodall-ui'
gem 'rmagick', :require => 'RMagick'
gem 'dragonfly', '~> 0.7.6'
gem 'factory_girl', '~> 1.3.2'
gem 'faker', '~> 0.3.1'
gem 'defensio'
gem 'fastercsv'
gem 'bson_ext'

group :development do
  gem 'capybara', '>= 0.3.9'
  gem 'rspec-rails', '>= 2.0.0.beta'
  gem 'database_cleaner'
  gem 'cucumber-rails'
  gem 'launchy'    # So you can do Then show me the page
  gem 'email_spec'
end

if RUBY_VERSION < '1.9'
  gem 'system_timer'
  gem "ruby-debug", ">= 0.10.3"
end

