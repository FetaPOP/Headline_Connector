# frozen_string_literal: true

require_relative 'providers'

module HeadlineConnector
  module Repository
    # Repository for Feed Entities
    class Feeds
      def self.all
        Database::FeedOrm.all.map { |a_feed_from_db| rebuild_entity(a_feed_from_db) }
      end

      def self.find(feed_entity)
        find_feed_id(feed_entity.feed_id)
      end

      def self.find_feed_id(id)
        db_feed_record = Database::FeedOrm.first(id: id)
        rebuild_entity(db_feed_record)
      end

      def self.find_feed_title(feed_title)
        db_feed_record = Database::FeedOrm.first(feed_title: feed_title)
        rebuild_entity(db_feed_record)
      end

      def self.create(feed_entity)
        raise 'Project already exists' if find(feed_entity)

        db_feed_record = PersistProject.new(feed_entity).create_feed_orm
        rebuild_entity(db_feed_record)
      end

      def self.rebuild_entity(db_feed_record)
        return nil unless db_feed_record

        Entity::Feed.new(
          id: db_feed_record.id,
          feed_id: db_feed_record.feed_id,
          feed_title: db_feed_record.feed_title,
          description: db_feed_record.description,
          tags: db_feed_record.tags.split(','),
          provider: Providers.rebuild_entity(db_feed_record.owner)
          # db_feed_record.owner is a Database::ProviderOrm object
        )
      end

      # Helper class to persist project and its members to database
      class PersistProject
        def initialize(feed_entity)
          @feed_entity = feed_entity
        end

        def create_feed_orm
          Database::FeedOrm.create(
            feed_id: @feed_entity.feed_id,
            feed_title: @feed_entity.feed_title,
            description: @feed_entity.description,
            tags: @feed_entity.tags.join(','),
            owner: Providers.db_find_or_create(@feed_entity.provider)
            # @feed_entity.provider is an Entity::Provider object
          )
        end
      end
    end
  end
end
