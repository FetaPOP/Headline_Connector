# frozen_string_literal: true

ENV['RACK_ENV'] ||= 'test'

require 'simplecov'
SimpleCov.start

require 'yaml'

require 'minitest/autorun'
require 'minitest/rg'

require_relative '../../init'

TOPIC_NAME = 'surfing'

# Helper method for acceptance tests
def homepage
    HeadlineConnector::App.config.APP_HOST
end
  