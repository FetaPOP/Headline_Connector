# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

require_relative 'item_representer'

# Represents essential feeds and text_cloud of a topic for API output
module HeadlineConnector
  module Representer
    # Represent a Topic entity as Json
    class Section < Roar::Decorator
      include Roar::JSON

      property :name
      collection :items, extend: Representer::Item, class: OpenStruct

    end
  end
end