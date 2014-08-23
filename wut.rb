require 'sinatra'
require 'sinatra/reloader'
require 'pathname'
require 'yaml'
require 'net/http'
require 'slim/logic_less'
require 'nokogiri'
require_relative 'tracker'

class WutApp < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  not_found do
    slim :error, layout: false, logic_less: false
  end

  get '/' do
    @warez = Tracker.new.warez
    slim :index
  end

  get '/pages' do
    Tracker.new.parser
  end
end
