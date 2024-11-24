# frozen_string_literal: true

require "bundler/inline"

gemfile do
  source "https://rubygems.org"
  gem "nokolexbor"
  gem "ostruct"
  gem "pstore"
end

require "open-uri"
require "nokolexbor"
require "yaml/store"

# Tracker
class Tracker
  attr_reader :warez

  def initialize
    @database = YAML::Store.new "tracking.yml"
    @warez ||= warez_repository.map { |data| OpenStruct.new(data) }
  end

  def run
    warez.each do |ware|
      update_ware! ware
    end
  end

  private

  def warez_repository
    @database.transaction { |db| db["warez"] || [] }
  end

  def update_ware!(ware)
    ware.parsed_value = Nokolexbor::HTML(URI.open(ware.url)).xpath(ware.xpath).text.strip
    ware.parsed_date = Time.now
  end

  def save!
    @database.transaction do |db|
      db["warez"] = warez.map(&:to_h)
    end
  end
end

Tracker.new.run
