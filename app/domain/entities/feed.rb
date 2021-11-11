# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

require_relative 'provider'

module HeadlineConnector
  module Entity
    # Entity class
    class Feed < Dry::Struct
      # Entity class of Feed
      include Dry.Types

      attribute :id,            Integer.optional
      attribute :feed_id,       Strict::String
      attribute :feed_title,    Strict::String
      attribute :description,   Strict::String
      attribute :tags,          Strict::Array
      attribute :provider,      Provider
    end

    def to_attr_hash
      to_hash.reject { |key, _| %i[id provider].include? key }
    end
  end
end
