# frozen_string_literal: true

require 'dry/transaction'

module HeadlineConnector
  module Service
    # Transaction to store topic from Youtube API to database
    class AddTopic
      include Dry::Transaction

      step :validate_input
      step :request_topic
      step :reify_topic

      private

      def validate_input(input)
        if input.success?
          Success(keyword: input[:keyword])
        else
          Failure(input.errors.values.join('; '))
        end
      end

      def request_topic(input)
        result = Gateway::Api.new(HeadlineConnector::App.config)
          .add_topic(input[:keyword])

        result.success? ? Success(result.payload) : Failure(result.message)
      rescue StandardError => e
        puts e.inspect + '\n' + e.backtrace
        Failure('Cannot request topic right now; please try again later')
      end

      def reify_topic(topic_json)
        Representer::Topic.new(OpenStruct.new)
          .from_json(topic_json)
          .then { |topic| Success(topic) }
      rescue StandardError
        Failure('Error in the topic -- please try again')
      end

      def store_topic(input)
        topic_entity =
          if (input[:remote_topic])
            # Search on Youtube and store those related videos/feeds that are not found in the database
            # This step is necessary for building the many-to-many feed-topic table in the database
            search_and_store_missing_feeds(input[:remote_topic])
            
            Repository::For.klass(Entity::Topic).create(input[:remote_topic])
          else
            input[:local_topic]
          end
        Success(topic_entity)
      rescue StandardError => error
        puts error.backtrace.join("\n")
        Failure('Having some troubles in store_topic() service')
      end

      # following are support methods that other services could use

      def topic_entity_from_youtube(input)
        Youtube::TopicMapper
        .new(App.config.YOUTUBE_TOKEN)
        .search_keyword(input[:keyword])
      rescue StandardError => error
        puts error.backtrace.join("\n")
        raise 'Having some troubles conducting search_keyword() on the Youtube Api.'
      end

      def topic_entity_in_database(input)
        Repository::For.klass(Entity::Topic).request_topic_keyword(input[:keyword])
      rescue StandardError
        puts error.backtrace.join("\n")
        raise 'Having some troubles conducting request_topic_keyword() on the database.'
      end

      def search_and_store_missing_feeds(topic_entity)
        topic_entity.related_videos_ids.each do |video_id|
          if (feed_entity = find_feed_id_in_database(video_id))
            feed_entity
          else
            youtube_feed_entity = request_video_from_youtube(video_id)
            store_feed_to_database(youtube_feed_entity)
          end
        end
      rescue StandardError => error
        puts error.backtrace.join("\n")
        raise 'Having some troubles about search_and_store_missing_feeds()'
      end

      def find_feed_id_in_database(video_id)
        Repository::For.klass(Entity::Feed).find_feed_id(video_id)
      rescue StandardError
        raise 'Having some troubles about find_feed_id_in_database()'
      end

      def request_video_from_youtube(video_id)
        Youtube::FeedMapper.new(App.config.YOUTUBE_TOKEN).request_video(video_id)
      rescue StandardError
        raise 'Having some troubles about request_video_from_youtube()'
      end

      def store_feed_to_database(youtube_feed_entity)
        Repository::For.klass(Entity::Feed).create(youtube_feed_entity)
      rescue StandardError
        raise 'Having some troubles about store_feed_to_database()'
      end
    end
  end
end