require 'sinatra'
require 'pathname'
require 'yaml'
require 'net/http'
require 'slim/logic_less'

class Tracker
  CACHE_DIR = Pathname.new('./cache')
  attr_accessor :warez

  def initialize(tracking: YAML::load_file('./tracking.yml'))
    @warez = tracking[:warez]
    get_pages if CACHE_DIR.children.size.zero?
  end

  def pages
    CACHE_DIR.children.map(&:read)
  end

  private
  def get_page(url)
    Net::HTTP.get(URI(url)).slice(/<body.+\/body>/m)
  end

  def get_pages
    warez.each do |ware|
      CACHE_DIR.join(ware[:title]).write get_page(ware[:url])
    end
  end
end

get '/' do
  @tracker = Tracker.new
  @warez = @tracker.warez
  slim :index
end

get '/pages' do
  Tracker.new.pages
end
