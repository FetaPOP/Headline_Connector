# frozen_string_literal: true

require 'http'
require_relative 'video'
require_relative 'channel'

module HeadlineConnector
  # Client Library for Youtube API
  class YoutubeApi
    YOUTUBE_PATH = 'https://youtube.googleapis.com/youtube/v3/'

    def initialize(api_key)
      @api_key = api_key
    end

    def data_collect(id)
      data_collect_response = Request.new(YOUTUBE_PATH, @api_key)
                                     .link(id).parse
      Video.new(data_collect_response, self)
    end

    # Sends out HTTP requests to Youtube
    class Request
      def initialize(resource_root, api_key)
        @resource_root = resource_root
        @api_key = api_key
      end

      def link(id)
        get(@resource_root + "videos?part=snippet&id=#{id}&key=" + @api_key)
      end

      def get(url)
        http_response = HTTP.headers('Accept' => 'application/json').get(url)

        Response.new(http_response).tap do |response|
          raise(response.error) unless response.successful?
        end
      end
    end

    # Decorates HTTP responses from Youtube with success/error reporting
    class Response < SimpleDelegator
      BadToken = Class.new(StandardError)
      Unauthorized = Class.new(StandardError)
      NotFound = Class.new(StandardError)

      HTTP_ERROR = {
        400 => Errors::BadToken,
        401 => Errors::Unauthorized,
        404 => Errors::NotFound
      }.freeze

      def successful?
        HTTP_ERROR.keys.include?(code) ? false : true
      end

      def error
        HTTP_ERROR[code]
      end
    end
  end
end
