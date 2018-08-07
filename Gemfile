source 'http://rubygems.org'

gem 'rake'
gem 'celluloid', '~> 0.17.0'
gem 'celluloid-io', '~> 0.17.0'

group :development do
  gem 'jeweler'

  gem 'guard'
  gem 'guard-rspec'
  gem 'growl'
end

group :test do
  gem 'dotenv'      # celluloid 0.17
  gem 'rspec-retry' # celluloid 0.17
  gem 'rb-fsevent'
  gem 'timecop'
  gem "codeclimate-test-reporter", :require => false
end

group :development, :test do
  gem 'byebug'
  gem 'rspec'
end
