# frozen_string_literal: true

# Helper to clean database during test runs
module DatabaseHelper
  def self.wipe_database
    # Ignore foreign key constraints when wiping tables
    HeadlineConnector::App.DB.run('PRAGMA foreign_keys = OFF')
    HeadlineConnector::Database::FeedOrm.map(&:destroy)
    HeadlineConnector::Database::ProviderOrm.map(&:destroy)
    HeadlineConnector::Database::TopicOrm.map(&:destroy)
    HeadlineConnector::App.DB.run('PRAGMA foreign_keys = ON')
  end
end
