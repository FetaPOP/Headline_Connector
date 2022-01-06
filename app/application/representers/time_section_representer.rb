# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

require_relative 'video_representer'

# Represents essential feeds and text_cloud of a topic for API output
module HeadlineConnector
  module Representer
    # Represent a Topic entity as Json
    class TimeSection < Roar::Decorator
      include Roar::JSON

      property :duration
      collection :video_list, extend: Representer::Video, class: OpenStruct

    end
  end
end