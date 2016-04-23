ENV['RAILS_ENV'] ||= 'test'

# Coveralls
require 'coveralls'
Coveralls.wear!('rails')

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

# class ActiveSupport::TestCase
#   fixtures :all
# end