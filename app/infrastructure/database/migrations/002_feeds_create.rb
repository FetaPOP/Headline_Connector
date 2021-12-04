# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:feeds) do
      primary_key :id
      foreign_key :provider_id, :providers

      String      :feed_id, unique: true
      String      :feed_title
      String      :description
      String      :tags # JSON string of the original array of tags

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
