# frozen_string_literal: true

require 'yaml/store'
# require 'open-uri'
# require 'nokogiri'

# Tracker
class Tracker
  def initialize
    @database = YAML::Store.new 'config/tracking.yml'
  end

  def warez
    @warez ||= warez_repository.map { |data| OpenStruct.new(data) }
  end

  def reload
    warez.map { |ware| self.ware = ware } and save!
  end

  private

  def warez_repository
    @database.transaction { |db| db['warez'] || [] }
  end

  def ware=(ware)
    ware.parsed_value = "wtf?" # Nokogiri::HTML(open(ware.url)).xpath(ware.xpath).text.strip
    ware.parsed_date  = Time.now
  end

  def save!
    @database.transaction do |db|
      db['warez'] = warez.map(&:to_h)
    end
  end
end
