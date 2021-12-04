# frozen_string_literal: true

require_relative '../../../helpers/spec_helper.rb'
require_relative '../../../helpers/vcr_helper.rb'
require_relative '../../../helpers/database_helper.rb'

require 'ostruct'

describe 'GenerateTextCloud Service Integration Test' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_youtube(recording: :none)
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Generate a Text Cloud' do
    before do
      DatabaseHelper.wipe_database
    end

    it 'HAPPY: should generate a textcloud for an topic existing in the database' do
      # GIVEN: a valid topic that exists locally

      HeadlineConnector::Service::AddTopic.new.call(
        HeadlineConnector::Forms::NewTopic.new.call(keyword: TOPIC_NAME)
      )

      # WHEN: we request to generate a text cloud
      result = HeadlineConnector::Service::GenerateTextCloud.new.call(keyword: TOPIC_NAME).value!

      # THEN: we should get a text cloud
      text_cloud = result[:textcloud]
      _(text_cloud).must_be_kind_of HeadlineConnector::Entity::TextCloud
      _(text_cloud.stats).wont_be_empty
    end

    it 'SAD: should not generate a textcloud for a topic not existing in the database' do
      # GIVEN: no topic exists locally

      # WHEN: we request to generate a text cloud
      result = HeadlineConnector::Service::GenerateTextCloud.new.call(keyword: TOPIC_NAME)

      # THEN: we should get failure
      _(result.failure?).must_equal true
    end
  end
end
