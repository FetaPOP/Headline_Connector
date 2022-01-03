# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

require_relative 'text_cloud_representer'
require_relative 'feed_representer'

# Represents essential feeds and text_cloud of a topic for API output
module HeadlineConnector
  module Representer
    # Represent a Topic entity as Json
    class KwList < Roar::Decorator
      include Roar::JSON

      collection :keywords

    end
  end
end
