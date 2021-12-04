# frozen_string_literal: true

require_relative '../../../helpers/spec_helper'
require_relative '../../../helpers/vcr_helper'

describe 'Tests Youtube API library' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_youtube(recording: :none)
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Feed information' do
    it 'HAPPY: should provide correct feed information' do
      feed = HeadlineConnector::Youtube::FeedMapper.new(YOUTUBE_TOKEN).request_video(VIDEO_ID)
      _(feed.feed_id).must_equal CORRECT['id']
      _(feed.feed_title).must_equal CORRECT['title']
      _(feed.description).must_equal CORRECT['description']
      _(feed.tags).must_equal CORRECT['tags']
      _(feed.provider.provider_title).must_equal CORRECT['channelTitle']
    end

    it 'SAD: should return an empty list of items due to non-existing feed ID' do
      wrong_id = 'ThisIdIsNotAValidId'
      empty_feed = HeadlineConnector::Youtube::FeedMapper
        .new(YOUTUBE_TOKEN)
        .request_video(wrong_id)
      _(empty_feed).must_be_nil
    end

    it 'SAD: should raise a BadToken exception' do
      _(proc do
        wrong_token = 'ThisToKenIsNotAValidToken'
        HeadlineConnector::Youtube::FeedMapper.new(wrong_token).request_video(VIDEO_ID)
      end).must_raise HeadlineConnector::Youtube::Api::Response::BadToken
    end
  end

  describe 'Provider information' do
    it 'HAPPY: should provide correct provider information' do
      provider = HeadlineConnector::Youtube::ProviderMapper.new(YOUTUBE_TOKEN).find_video_provider(VIDEO_ID)
      _(provider.provider_id).must_equal CORRECT['channelId']
      _(provider.provider_title).must_equal CORRECT['channelTitle']
    end
  end
end