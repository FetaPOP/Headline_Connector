# frozen_string_literal: true

require 'dry-validation'

module HeadlineConnector
  module Forms
    class NewTopic < Dry::Validation::Contract
      KW_REGEX = %r{.}.freeze
      # Any character except line break

      params do
        required(:keyword).filled(:string)
      end

       rule(:keyword) do
         unless KW_REGEX.match?(value)
           key.failure('Invalid keyword for search')
         end
      end
    end
  end
end
