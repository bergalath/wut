class Tracker
  CACHE_DIR = Pathname.new('./cache')
  attr_accessor :warez

  def initialize(tracking: YAML::load_file('./tracking.yml'))
    @warez = tracking[:warez].map { |ware_hash| OpenStruct.new(ware_hash) }
    get_pages if CACHE_DIR.children.size.zero?
  end

  def pages
    CACHE_DIR.children.map(&:read)
  end

  def parser
    warez.map do |ware|
      Nokogiri::HTML(CACHE_DIR.join(ware.title).read).xpath(ware.xpath).text
    end.join(' ')
  end

  private
  def get_page(url)
    Net::HTTP.get(URI(url)).slice(/<body.+\/body>/m)
  end

  def get_pages
    warez.each do |ware|
      CACHE_DIR.join(ware.title).write get_page(ware.url)
    end
  end
end
