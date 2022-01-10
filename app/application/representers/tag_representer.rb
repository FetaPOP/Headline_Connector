# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

# Represents essential feeds and text_cloud of a topic for API output
module HeadlineConnector
  module Representer
    # Represent a Topic entity as Json
    class Tag < Roar::Decorator
      include Roar::JSON

      collection :this_week
      collection :this_month
      collection :this_year
      collection :before_this_year

    end
  end
end