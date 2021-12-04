# frozen_string_literal: true

require_relative 'feeds'

module HeadlineConnector
  module Repository
    # Repository for Feed Entities
    class Topics
      def self.all
        Database::TopicOrm.all.map { |a_topic_from_db| rebuild_entity(a_topic_from_db) }
      end

      def self.find(topic_entity)
        find_topic_keyword(topic_entity.keyword)
      end

      def self.find_topic_keyword(keyword)
        rebuild_entity Database::TopicOrm.first(keyword: keyword)
      end
 
      def self.rebuild_entity(db_topic_record)
        return nil unless db_topic_record

        Entity::Topic.new(
          id: db_topic_record.id,
          keyword: db_topic_record.keyword,
          related_videos_ids: Feeds.extract_many_feed_ids(db_topic_record.related_feeds)
        )
      end

      def self.create(topic_entity)
        raise 'Topic already exists' if find(topic_entity)
        db_topic_record = TopicPersistProject.new(topic_entity).call
        rebuild_entity(db_topic_record)
      end

      class TopicPersistProject
        def initialize(topic_entity)
          @topic_entity = topic_entity
        end

        def create_topic
          Database::TopicOrm.create(keyword: @topic_entity.keyword)
        end

        def call
=begin
          Do make sure that the app has stored all related videos/feeds of the topic
          to the database before calling this method
=end 
          create_topic.tap do |a_topic_from_db|
            @topic_entity.related_videos_ids.each do |a_related_video_id|
              a_topic_from_db.add_related_feed(Feeds.first(a_related_video_id))
            end
          end
        rescue
          raise 'Have some troubles in building the connection between topic and its related feeds'
        end
      end
    end
  end
end
