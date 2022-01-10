# frozen_string_literal: true

require 'dry/transaction'

module HeadlineConnector
  module Service
    # Transaction to store topic from Youtube API to database
    class GetHeadlineCluster
      include Dry::Transaction

      step :request_headline_cluster
      step :reify_headline_cluster

      private

      def request_headline_cluster()
        result = Gateway::Api.new(App.config).get_headline_cluster()
        result.success? ? Success(result.payload) : Failure(result.message)

      rescue StandardError => e
        puts e.inspect
        Failure('Having some troubles get reply of request_headline_cluster() from the Api')
      end

      def reify_headline_cluster(h)
        Representer::HeadlineCluster.new(OpenStruct.new)
          .from_json(h)
          .then { |headline_cluster| Success(headline_cluster) }

      rescue StandardError => e
        puts e.full_message
        Failure('Error in the topic -- please try again')
      end
    end
  end
end