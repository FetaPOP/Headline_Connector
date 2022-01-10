# frozen_string_literal: true

require 'dry/transaction'

module HeadlineConnector
  module Service
    # Analyzes contributions to a project
    class GenerateTextCloud
      include Dry::Transaction

      step :validate_topic_in_api
      step :request_text_cloud
      step :reify_textCloud

      private

      def validate_topic_in_api(input)
        result = Gateway::Api.new(App.config).add_topic(input[:keyword])
        result.success? ? Success(input) : Failure('Topic validation in the Api failed')

      rescue StandardError => error
        puts error.backtrace.join("\n")
        Failure('Having some troubles validating topics in the Api database')
      end

      def request_text_cloud(input)
        result = Gateway::Api.new(App.config).generate_textCloud(input[:keyword])
        result.success? ? Success(result.payload) : Failure(result.message)
        
      rescue StandardError
        Failure('Having some troubles get reply of request_text_cloud() from the Api')
      end

      def reify_textCloud(text_cloud_json)
        Representer::TextCloud.new(OpenStruct.new)
          .from_json(text_cloud_json)
          .then do |text_cloud|
            Success(text_cloud)
          end
      rescue StandardError
        Failure('Error in our text cloud generator -- please try again')
      end      
    end
  end
end



            
