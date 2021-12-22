# frozen_string_literal: true

require_relative '../../../helpers/spec_helper.rb'

describe 'GenerateTextCloud Service Integration Test' do
  it 'HAPPY: should generate a textcloud for an topic existing in the database' do
    # GIVEN: a valid topic that exists locally

    # WHEN: we request to generate a text cloud
    result = HeadlineConnector::Service::GenerateTextCloud.new.call(keyword: TOPIC_NAME)

    # THEN: we should get a text cloud
    _(result.success?).must_equal true
    # ..and contain some information about the text_cloud
    text_cloud = result.value!
    _(text_cloud.stats).wont_be_nil
  end
end
