# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module HeadlineConnector
  module Entity
    # Entity class
    class Provider < Dry::Struct
      # Entity class of Feed
      include Dry.Types

      attribute :id,             Integer.optional
      attribute :provider_id,    Strict::String
      attribute :provider_title, Strict::String

      def to_attr_hash
        to_hash.reject { |key, _| [:id].include? key }
      end
    end
  end
end
