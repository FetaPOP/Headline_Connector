# frozen_string_literal: true

require 'dry/transaction'

module HeadlineConnector
  module Service
    # Analyzes contributions to a project
    class GenerateTextCloud
      include Dry::Transaction

      step :retrieve_topic
      step :request_videos
      step :generate_text_cloud

      private

      def retrieve_topic(input)
        input[:topic] = Repository::For.klass(Entity::Topic).find_topic_keyword(input[:keyword])

        input[:topic] ? Success(input) : Failure('Topic not found')

      rescue StandardError => error
        puts error.backtrace.join("\n")
        Failure('Having some troubles conducting retrieve_topic() on the database')
      end

      def request_videos(input)
        # Assume that all related videos are already in the database
        input[:related_feeds_entities] = input[:topic].related_videos_ids.map do |video_id|
          Repository::For.klass(Entity::Feed).find_feed_id(video_id)
        end
        
        Success(input)
        
      rescue StandardError => error
        puts error.backtrace.join("\n")
        Failure('Having some troubles conducting request_videos() to the Youtube Api')
      end

      def generate_text_cloud(input)
          input[:textcloud] = Mapper::TextCloudMapper.new(input[:related_feeds_entities]).generate_textcloud
    
          input[:textcloud] ? Success(input) : Failure('No textcloud')
      rescue StandardError => error
        puts error.backtrace.join("\n")
        Failure('Having some troubles conducting generate_text_cloud() calculations')
      end
    end
  end
end



            
