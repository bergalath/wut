require 'yaml/store'
require 'open-uri'
require 'nokogiri'

class Tracker
  def initialize()
    @database = YAML::Store.new 'lib/tracking.yml'
  end

  def warez
    @warez ||= get_warez.map { |data| OpenStruct.new(data) }
  end

  def reload
    warez.map { |ware| set_ware(ware) } && save!
  end

  private
    def get_warez
      @database.transaction { |db| db['warez'] || [] }
    end

    def set_ware(ware)
      ware.parsed_value = Nokogiri::HTML(open(ware.url)).xpath(ware.xpath).text.strip
      ware.parsed_date  = Time.now
    end

    def save!
      @database.transaction do |db|
        db['warez'] = warez.map(&:to_h)
      end
    end
end
