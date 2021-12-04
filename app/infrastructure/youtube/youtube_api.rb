# frozen_string_literal: true

require 'http'

module HeadlineConnector
  module Youtube
    # Client Library for Youtube API
    class Api
      YOUTUBE_API_ROOT = 'https://youtube.googleapis.com/youtube/v3'

      def initialize(api_key)
        @api_key = api_key
      end

      def request_video(video_id)
        Request.new(YOUTUBE_API_ROOT, @api_key).request_video(video_id).parse
      end

      def search_keyword(keyword, max_results)
        Request.new(YOUTUBE_API_ROOT, @api_key).search_keyword(keyword, max_results).parse
      end

      # Sends out HTTP requests to Youtube
      class Request
        def initialize(resource_root, api_key)
          @resource_root = resource_root
          @api_key = api_key
        end

        def get(url)
          http_response = HTTP.headers('Accept' => 'application/json').get(url)

          Response.new(http_response).tap do |response|
            raise(response.error) unless response.successful?
          end
        end

        def request_video(video_id)
          get("#{@resource_root}/videos?part=snippet&id=#{video_id}&key=#{@api_key}")
        end

        def search_keyword(keyword, max_results = 50)
          get("#{@resource_root}/search?part=snippet&maxResults=#{max_results}&q=#{keyword}&key=#{@api_key}")
        end
      end

      # Decorates HTTP responses from Youtube with success/error
      class Response < SimpleDelegator
        BadToken = Class.new(StandardError)
        Unauthorized = Class.new(StandardError)
        NotFound = Class.new(StandardError)

        HTTP_ERROR = {
          400 => BadToken,
          401 => Unauthorized,
          404 => NotFound
        }.freeze

        def successful?
          !HTTP_ERROR.keys.include?(code)
        end

        def error
          HTTP_ERROR[code]
        end
      end
    end
  end
end
