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
  def initialize
    @database = YAML::Store.new "tracking.yml"
  end

  def warez = @warez ||= repository.map { |data| OpenStruct.new(data) }

  def run = process_warez! && save!

  private

  def repository = @database.transaction { |db| db["warez"] } || []

  def save! = @database.transaction { |db| db["warez"] = warez.map(&:to_h) }

  def process_warez!
    warez.each do |ware|
      parsed_value = Nokolexbor::HTML(URI.open(ware.url)).xpath(ware.xpath).text.strip
      puts("Souci, rien trouvé !") && next if parsed_value.empty?

      if parsed_value != ware.value
        puts "Update available !!"
        ware.value = parsed_value
      else
        puts "NOOP !"
      end
    end
  end
end

Tracker.new.run
