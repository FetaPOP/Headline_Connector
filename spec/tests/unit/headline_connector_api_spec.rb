# frozen_string_literal: true

require_relative '../../helpers/spec_helper.rb'

describe 'Unit test of Headline_Connector API gateway' do
  it 'must report alive status' do
    alive =  HeadlineConnector::Gateway::Api.new(HeadlineConnector::App.config).alive?
    _(alive).must_equal true
  end

  it 'can add a topic' do
    res = HeadlineConnector::Gateway::Api.new(HeadlineConnector::App.config).add_topic(TOPIC_NAME)

    _(res.success?).must_equal true
    _(res.parse["keyword"]).must_equal TOPIC_NAME
    _(res.parse["related_videos_ids"]).wont_be_nil
  end

  it 'can generate text cloud' do
    # Need to store topics first to be able to generate textcloud
    HeadlineConnector::Gateway::Api.new(HeadlineConnector::App.config).add_topic(TOPIC_NAME)
    res = HeadlineConnector::Gateway::Api.new(HeadlineConnector::App.config).generate_textCloud(TOPIC_NAME)

    _(res.success?).must_equal true
    _(res.parse["stats"]).wont_be_nil
  end
end