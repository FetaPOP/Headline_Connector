# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

require_relative 'feed_representer'

module HeadlineConnector
  module Representer
    # Represents list of feeds for API output
    class Feeds < Roar::Decorator
      include Roar::JSON

      collection :feeds, extend: Representer::Feed,
    end
  end
end
