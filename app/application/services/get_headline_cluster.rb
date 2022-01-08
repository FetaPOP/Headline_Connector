# frozen_string_literal: true

require 'dry/transaction'

module HeadlineConnector
  module Service
    # Transaction to store topic from Youtube API to database
    class GetHeadlineCluster
      include Dry::Transaction

      step :validate_input
      step :request_headline_cluster
      step :reify_headline_cluster

      private

      def validate_input(input)
        if input.success?
          Success(input)
        else
          Failure(input.errors.values.join('; '))
        end
      end

      def request_headline_cluster(input)
        result = Gateway::Api.new(App.config).get_headline_cluster()
        result.success? ? Success(result.payload) : Failure(result.message)

      rescue StandardError => e
        puts e.inspect + '\n' + e.backtrace
        Failure('Having some troubles get reply of request_headline_cluster() from the Api')
      end

      def reify_headline_cluster(headline_cluster_json)
        Representer::HeadlineCluster.new(OpenStruct.new)
          .from_json(headline_cluster_json)
          .then { |headline_cluster| Success(headline_cluster) }

      rescue StandardError
        Failure('Error in the topic -- please try again')
      end
    end
  end
end