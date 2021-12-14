# frozen_string_literal: true

require 'dry/transaction'

module HeadlineConnector
  module Service
    # Analyzes contributions to a project
    class GenerateTextCloud
      include Dry::Transaction

      step :validate_topic
      step :generate_text_cloud
      step: reify_textCloud

      private

      def validate_topic(input)
        input[:topic] = Repository::For.klass(Entity::Topic).find_topic_keyword(input[:keyword])

        if input[:topic] 
          Success(input) 
        else
          Failure('Topic not found')
        end
      end
      
      def generate_text_cloud(input)
        result = Gateway::Api.new(HeadlineConnector::Api.config)
          .generate_textCloud(input[:topic])

        result.success? ? Success(result.payload) : Failure(result.message)
      rescue StandardError
        Failure('Cannot generate text cloud right now; please try again later')
      end

      def reify_textCloud(text_cloud_json)
        Representer::TextCloud.new(OpenStruct.new)
          .from_json(text_cloud_json)
          .then { |text_cloud| Success(text_cloud) }
      rescue StandardError
        Failure('Error in our text cloud generator -- please try again')
      end
      
    end
  end
end



            
