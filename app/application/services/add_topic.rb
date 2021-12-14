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
    end
  end
end