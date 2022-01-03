# frozen_string_literal: true

require 'dry/transaction'

module HeadlineConnector
  module Service
    # Transaction to store topic from Youtube API to database
    class GetKwList
      include Dry::Transaction

      step :validate_input
      step :request_kw_list
      step :reify_topic

      private

      def validate_input(input)
        if input.success?
          Success(input)
        else
          Failure(input.errors.values.join('; '))
        end
      end

      def request_kw_list(input)
        result = Gateway::Api.new(App.config).get_kw_list()
        result.success? ? Success(result.payload) : Failure(result.message)

      rescue StandardError => e
        puts e.inspect + '\n' + e.backtrace
        Failure('Having some troubles get reply of request_kw_list() from the Api')
      end

      def reify_topic(topic_json)
        Representer::KwList.new(OpenStruct.new)
          .from_json(topic_json)
          .then { |topic| Success(topic) }

      rescue StandardError
        Failure('Error in the topic -- please try again')
      end
    end
  end
end