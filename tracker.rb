# frozen_string_literal: true

require "bundler/inline"
gemfile do
  source "https://rubygems.org"
  ruby "> 3.3"
  gem "nokolexbor"
  gem "ostruct"
  gem "pstore"
  gem "rss"
end
require "yaml/store"

# Tracker
class Tracker
  def initialize
    @database = YAML::Store.new "tracking.yml"
  end

  def warez = @warez ||= repository.map { OpenStruct.new _1 }

  def run = process_warez! && save!

  private

  def repository = @database.transaction { _1["warez"] } || []

  def save! = @database.transaction { _1["warez"] = warez.map(&:to_h) }

  def process_warez!
    warez.each do |ware|
      parsed_value = fetch_value ware
      puts("Rien trouvé pour #{ware.title} ! Xpath ou URL ok ?") && next if parsed_value.empty?

      next if parsed_value == ware.value

      puts "Màj disponible pour #{ware.title} : #{parsed_value}"
      ware.value = parsed_value
    end
  end

  def fetch_value(ware)
    doc = URI.parse(ware.url).open
    if ware.xpath == :rss
      RSS::Parser.parse(doc).items.first.title
    else
      Nokolexbor::HTML(doc).xpath(ware.xpath).text.strip
    end
  end
end

Tracker.new.run
