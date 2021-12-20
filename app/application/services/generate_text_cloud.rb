# frozen_string_literal: true

require 'dry/transaction'

module HeadlineConnector
  module Service
    # Analyzes contributions to a project
    class GenerateTextCloud
      include Dry::Transaction

      step :generate_text_cloud
      step :reify_textCloud

      private

      def generate_text_cloud(input)
          input[:textcloud] = Mapper::TextCloudMapper.new(input[:related_feeds_entities]).generate_textcloud
    
          result = Gateway::Api.new(HeadlineConnector::Api.config)
            .generate_textCloud(input[:text_cloud])

          result.success? ? Success(result.payload) : Failure(result.message)
      rescue StandardError
        Failure('Having some troubles conducting generate_text_cloud() calculations')
      end

      def reify_textCloud(text_cloud_json)
        Representer::TextCloud.new(OpenStruct.new)
          .from_json(text_cloud_json)
          .then { |text_cloud| Success(text_cloud) }
      rescue StandardError
        Failure('Error in our text cloud generator -- please try again')
      end

      # Helper funtions
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
      
    end
  end
end



            
