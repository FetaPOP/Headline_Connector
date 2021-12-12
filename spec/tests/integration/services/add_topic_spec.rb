# frozen_string_literal: true

require_relative '../../../helpers/spec_helper.rb'

describe 'Integration test of AddTopic service and API gateway' do
  it 'must add a legitimate topic' do
    # WHEN we request to add a topic
    user_input = HeadlineConnector::Forms::NewTopic.new.call(keyword: TOPIC_NAME)

    # WHEN: the service is called with the request form object
    topic_entity_result = HeadlineConnector::Service::AddTopic.new.call(user_input)

    # THEN: the result should report success
    _(topic_entity_result.success?).must_equal true
    # ..and provide a topic entity with the right details
    rebuilt_topic_entity = topic_entity_result.value!
    _(rebuilt_topic_entity.related_videos_ids.length()).must_equal topic_entity.related_videos_ids.length()
    
    topic_entity.related_videos_ids.each do |video_id|
      _(rebuilt_topic_entity.related_videos_ids.include? video_id).must_equal true
    end
  end
end
