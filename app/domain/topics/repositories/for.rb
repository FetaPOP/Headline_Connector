# frozen_string_literal: true

require_relative 'feeds'
require_relative 'providers'

module HeadlineConnector
  module Repository
    # Finds the right repository for an entity object or class
    module For
      ENTITY_REPOSITORY = {
        Entity::Provider => Providers,
        Entity::Feed => Feeds,
        Entity::Topic => Topics,
      }.freeze

      def self.klass(entity_klass)
        ENTITY_REPOSITORY[entity_klass]
      end

      def self.entity(entity_object)
        ENTITY_REPOSITORY[entity_object.class]
      end
    end
  end
end
