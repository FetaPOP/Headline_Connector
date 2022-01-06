# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

require_relative 'provider_representer'

module HeadlineConnector
  module Representer
    # Represents a Feed's info
    class Item < Roar::Decorator
      include Roar::JSON

      property :url
      property :title
      property :abstract
      property :img
      property :tag
    
    end
  end
end