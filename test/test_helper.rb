# Ensure our tests ALWAYS have the environment set to 'test'
ENV['RACK_ENV'] = 'test'

gem 'minitest'

require 'minitest/autorun'
require 'minitest/sequel'
require 'minitest/spec'
require 'minitest/reporters'
require 'rack/test'
require 'pry'

require File.expand_path('../../api_base.rb', __FILE__)

reporter_options = { color: true }
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(reporter_options)]
