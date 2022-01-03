# frozen_string_literal: true

require_relative '../../../helpers/spec_helper.rb'

describe 'Integration test of AddTopic service and API gateway' do
  it 'must add a legitimate topic' do
    # WHEN we request to add a topic
    user_input = HeadlineConnector::Forms::NewTopic.new.call(keyword: TOPIC_NAME)

    # WHEN: the service is called with the request form object
    result = HeadlineConnector::Service::AddTopic.new.call(user_input)

    # THEN: the result should report success
    _(result.success?).must_equal true
    # ..and contain some information about the topic
    topic = result.value!
    _(topic.keyword).wont_be_empty
    _(topic.related_videos_ids).wont_be_nil
  end
end
