# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

module HeadlineConnector
  module Representer
    # Represents a Feed's info
    class Feed < Roar::Decorator
      include Roar::JSON

      property :feed_title
      property :description
      property :tags
      property :provider
    end
  end
end
