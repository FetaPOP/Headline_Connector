# frozen_string_literal: true

require_relative '../../helpers/spec_helper.rb'

describe 'Unit test of Headline Connector API gateway' do
  it 'must report alive status' do
    alive = HeadlineConnector::Gateway::Api.new(HeadlineConnector::App.config).alive?
    _(alive).must_equal true
  end

  it 'must be able to add a topic' do
    res = HeadlineConnector::Gateway::Api.new(HeadlineConnector::App.config)
      .add_topic(TOPIC_NAME)

    _(res.success?).must_equal true
  end

  it 'must return a text cloud of a topic' do
    # GIVEN a topic is in the database
    HeadlineConnector::Gateway::Api.new(HeadlineConnector::App.config)
      .add_topic(TOPIC_NAME)

    # WHEN we request an text cloud
    req = TOPIC_NAME

    res = HeadlineConnector::Gateway::Api.new(HeadlineConnector::App.config)
      .generate_textCloud(req)

    # THEN we should see a single topic in the list
    _(res.success?).must_equal true
  end
end
