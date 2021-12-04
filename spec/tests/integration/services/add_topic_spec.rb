# frozen_string_literal: true

require_relative '../../../helpers/spec_helper.rb'
require_relative '../../../helpers/vcr_helper.rb'
require_relative '../../../helpers/database_helper.rb'

describe 'GenerateTextCloud Service Integration Test' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_youtube(recording: :none)
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Retrieve and store topic' do
    before do
      DatabaseHelper.wipe_database
    end

    it 'HAPPY: should be able to find and save topic to database' do
      # GIVEN: a valid keyword request for a search result list of youtube videos:
      topic_entity = HeadlineConnector::Youtube::TopicMapper.new(YOUTUBE_TOKEN).search_keyword(TOPIC_NAME)
      user_input = HeadlineConnector::Forms::NewTopic.new.call(keyword: TOPIC_NAME)

      # WHEN: the service is called with the request form object
      topic_entity_result = HeadlineConnector::Service::AddTopic.new.call(user_input)

      # THEN: the result should report success.
      _(topic_entity_result.success?).must_equal true

      # ..and provide a topic entity with the right details
      rebuilt_topic_entity = topic_entity_result.value!
      
      _(rebuilt_topic_entity.related_videos_ids.length()).must_equal topic_entity.related_videos_ids.length()
      
      topic_entity.related_videos_ids.each do |video_id|
        _(rebuilt_topic_entity.related_videos_ids.include? video_id).must_equal true
      end
    end

    it 'HAPPY: should find and return existing project in database' do
      # GIVEN: a valid keyword request for a topic already in the database:
      user_input = HeadlineConnector::Forms::NewTopic.new.call(keyword: TOPIC_NAME)
      first_rebuilt_topic_entity = HeadlineConnector::Service::AddTopic.new.call(user_input).value!

      # WHEN: the service is called with the request form object
      topic_entity_result = HeadlineConnector::Service::AddTopic.new.call(user_input)

      # THEN: the result should report success..
      _(topic_entity_result.success?).must_equal true

      # ..and find the same project that was already in the database
      second_rebuilt_topic_entity = topic_entity_result.value!
      _(second_rebuilt_topic_entity.id).must_equal(first_rebuilt_topic_entity.id)

      # ..and provide a project entity with the right details
      _(first_rebuilt_topic_entity.related_videos_ids.length()).must_equal second_rebuilt_topic_entity.related_videos_ids.length()
      
      first_rebuilt_topic_entity.related_videos_ids.each do |video_id|
        _(second_rebuilt_topic_entity.related_videos_ids.include? video_id).must_equal true
      end
    end

    it 'BAD: should gracefully fail for invalid keyword' do
      # GIVEN: an invalid keyword request is formed
      BAD_TOPIC_NAME = ''
      user_input = HeadlineConnector::Forms::NewTopic.new.call(keyword: BAD_TOPIC_NAME)

      # WHEN: the service is called with the request form object
      topic_entity_result = HeadlineConnector::Service::AddTopic.new.call(user_input)

      # THEN: the service should report failure with an error message
      _(topic_entity_result.success?).must_equal false
      _(topic_entity_result.failure.downcase).must_include 'invalid'
    end
  end
end
