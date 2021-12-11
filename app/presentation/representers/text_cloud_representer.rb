# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

module HeadlineConnector
  module Representer
    # Presents a text_cloud of a topic keyword
    class TextCloud < Roar::Decorator
      include Roar::JSON

      collection :stats, class: OpenStruct
    end
  end
end
