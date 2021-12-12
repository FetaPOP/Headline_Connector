# frozen_string_literal: true

require_relative '../../helpers/acceptance_helper'
require_relative 'pages/home_page'

describe 'Homepage Acceptance Tests' do
  include PageObject::PageFactory
  before do
    # DatabaseHelper.wipe_database
    # @headless = Headless.new
    @browser = Watir::Browser.new
  end

  after do
    @browser.close
    # @headless.destroy
  end

  describe 'Visit Home Page' do
    it '(Happy) should not see projects if none created' do
      # GIVEN: user has no topics
      # WHEN: they visit the home page
      visit HomePage do |page|
        _(page.title_heading).must_equal 'HeadlineConnector'
        _(page.topic_input_element.present?).must_equal true
        _(page.add_button_element.present?).must_equal true

        _(page.success_message_element.present?).must_equal true
        _(page.success_message.downcase).must_equal 'start'
      end
    end
  end

  describe 'Add Topic and Generate Text Cloud' do
    it '(HAPPY) should be able to generate a text cloud' do
      # GIVEN: user is on the home page without any topics
      visit HomePage do |page|
        # WHEN: they add a topic keyword and submit
        good_topic = TOPIC_NAME
        page.add_new_topic(good_topic)

        # THEN: they should find themselves on the topic's page
        @browser.url.include? "topic"
        @browser.url.include? TOPIC_NAME
      end
    end

    it '(BAD) should not be able to generate a text cloud' do
      # GIVEN: user is on the home page
      vist HomePage do |page|
        # WHEN: they type in an invalid topic and submit
        bad_topic = 'ewjq7asai'
        page.add_new_topic(bad_topic)

        # THEN: they should see a warning message
        _(page.warning_message_downcase).must_include 'invalid'
      end
    end
  end
end
