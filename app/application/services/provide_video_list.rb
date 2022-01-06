# frozen_string_literal: true

require 'dry/transaction'

module HeadlineConnector
  module Service
    # Transaction to store topic from Youtube API to database
    class ProvideVideoList
      include Dry::Transaction

      step :validate_input
      step :request_video_list
      step :reify_video_list

      private

      def validate_input(input)
        if input.success?
          Success(input)
        else
          Failure(input.errors.values.join('; '))
        end
      end

      def request_video_list(input)
        result = Gateway::Api.new(App.config).provide_video_list(input[:tag])
        result.success? ? Success(result.payload) : Failure(result.message)

      rescue StandardError => e
        puts e.inspect + '\n' + e.backtrace
        Failure('Having some troubles get reply of request_video_list() from the Api')
      end

      def reify_video_list(video_list_json)
        Representer::Topic.new(OpenStruct.new)
          .from_json(video_list_json)
          .then { |tag| Success(tag) }

      rescue StandardError
        Failure('Error in the tag -- please try again')
      end
    end
  end
end