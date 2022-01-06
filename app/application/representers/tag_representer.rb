# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

require_relative 'time_section_representer'

# Represents essential feeds and text_cloud of a topic for API output
module HeadlineConnector
  module Representer
    # Represent a Topic entity as Json
    class Tag < Roar::Decorator
      include Roar::JSON

      collection :time_sections, extend: Representer::TimeSection, class: OpenStruct

    end
  end
end