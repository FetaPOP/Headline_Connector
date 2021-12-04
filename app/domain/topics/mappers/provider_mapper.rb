# frozen_string_literal: true

module HeadlineConnector
  module Youtube
    # Youtube Mapper: YoutubeApi -> provider entity
    class ProviderMapper
      def initialize(api_key, gateway_class = Youtube::Api)
        @api_key = api_key
        @gateway_class = gateway_class
        @gateway = @gateway_class.new(@api_key)
      end

      def find_video_provider(video_id)
        data = @gateway.request_video(video_id)
        build_entity(data)
      end

      def build_entity(data)
        DataMapper.new(data).build_entity
      end

      def self.build_entity(data)
        DataMapper.new(data).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(data)
          @data = data
        end

        def build_entity
          return nil if @data['items'].empty?

          HeadlineConnector::Entity::Provider.new(
            id: nil,
            provider_id: provider_id,
            provider_title: provider_title
          )
        end

        def provider_id
          @data['items'][0]['snippet']['channelId']
        end

        def provider_title
          @data['items'][0]['snippet']['channelTitle']
        end
      end
    end
  end
end
