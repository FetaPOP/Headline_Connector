# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

module HeadlineConnector
  module Representer
    # Represents a Provider's info
    class Provider < Roar::Decorator
      include Roar::JSON

      property :provider_title
    end
  end
end
