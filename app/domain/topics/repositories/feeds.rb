# frozen_string_literal: true

require_relative 'providers'
require 'json'

module HeadlineConnector
  module Repository
    # Repository for Feed Entities
    class Feeds
      def self.all
        Database::FeedOrm.all.map { |a_feed_from_db| rebuild_entity(a_feed_from_db) }
      end

      def self.first(feed_id)
        Database::FeedOrm.first(feed_id: feed_id)
      end

      def self.find(feed_entity)
        find_feed_id(feed_entity.feed_id)
      end

      def self.find_feed_id(feed_id)
        rebuild_entity Database::FeedOrm.first(feed_id: feed_id)
      end

      def self.find_feed_title(feed_title)
        rebuild_entity Database::FeedOrm.first(feed_title: feed_title)
      end
 
      def self.rebuild_entity(db_feed_record)
        return nil unless db_feed_record

        Entity::Feed.new(
          id: db_feed_record.id,
          feed_id: db_feed_record.feed_id,
          feed_title: db_feed_record.feed_title,
          description: db_feed_record.description,
          tags: JSON.parse(db_feed_record.tags),
          provider: Providers.rebuild_entity(db_feed_record.provider)
          # db_feed_record.provider is a Database::ProviderOrm object
        )
      end

      def self.extract_many_feed_ids(array_of_feed_records_from_db)
        array_of_feed_records_from_db.map do |a_feed_from_db|
          a_feed_from_db.feed_id
        end
      end

      def self.create(feed_entity)
        raise 'Feed already exists' if find(feed_entity)

        db_feed_record = Database::FeedOrm.create(
          feed_id: feed_entity.feed_id,
          feed_title: feed_entity.feed_title,
          description: feed_entity.description,
          tags: JSON.generate(feed_entity.tags),
          provider: Providers.db_find_or_create(feed_entity.provider)
        )
        
        rebuild_entity(db_feed_record)
      end
    end
  end
end
