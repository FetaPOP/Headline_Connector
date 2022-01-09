# frozen_string_literal: true

require_relative '../../helpers/acceptance_helper'
require_relative 'pages/topic_page'
require_relative 'pages/home_page'

describe 'Topic Page Acceptance Tests' do
  include PageObject::PageFactory

  before do
    # Headless error? 
    # @headless = Headless.new
    @browser = Watir::Browser.new
  end

  after do
    @browser.close
    # @headless.destroy
  end

  it '(HAPPY) should see list of tags if topic exists' do
    # GIVEN: user has requested and created a topic
    visit HomePage do |page|
      good_topic = TOPIC_NAME
      page.add_new_topic(good_topic)
    end

    # WHEN: user goes to the topic page
    visit(TopicPage, using_params: { keyword: TOPIC_NAME }) do |page|
      # THEN: they should see the list of tags
      _(page.textcloud_table_element.present?).must_equal true
    end
  end

  it '(HAPPY) should report an error if topic not requested' do
    # GIVEN: user has not requested a topic yet, even though it exists
    topic = HeadlineConnector::Youtube::TopicMapper
      .new(YOUTUBE_TOKEN)
      .search_keyword(TOPIC_NAME)
      HeadlineConnector::Repository::For.entity(topic).create(topic)

    # WHEN: they see directly the topic's tags
    visit(TopicPage, using_params: { keyword: TOPIC_NAME })

    # THEN: they should should be returned to the homepage with a warning
    on_page HomePage do |page|
      _(page.warning_message.downcase).must_include 'request'
    end
  end
end
