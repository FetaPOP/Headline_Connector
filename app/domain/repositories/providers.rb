# frozen_string_literal: true

require_relative 'feeds'

module HeadlineConnector
  module Repository
    # Repository for Provider Entities
    class Providers
      def self.find_id(id)
        rebuild_entity Database::ProviderOrm.first(id: id)
      end

      def self.find_provider_id(provider_id)
        rebuild_entity Database::ProviderOrm.first(provider_id: provider_id)
      end

      def self.rebuild_entity(db_provider_record)
        return nil unless db_provider_record

        Entity::Provider.new(
          id: db_provider_record.id,
          provider_id: db_provider_record.provider_id,
          provider_title: db_provider_record.provider_title
        )
      end

      def self.db_find_or_create(provider_entity)
        Database::ProviderOrm.find_or_create(provider_entity.to_attr_hash)
      end
    end
  end
end
