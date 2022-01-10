# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

module HeadlineConnector
  module Representer
    # Represents a Feed's info
    class Item < Roar::Decorator
      include Roar::JSON

      property :section
      property :article_url
      property :title
      property :abstract
      property :img
      property :tag
    
    end
  end
end