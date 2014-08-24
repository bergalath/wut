require 'sinatra'
require 'slim/logic_less'
require_relative 'tracker'

class WutApp < Sinatra::Base
  not_found do
    slim :error, layout: false, logic_less: false
  end

  get '/' do
    @warez = Tracker.new.warez
    slim :index
  end

  get '/reload' do
    Tracker.new.reload && redirect('/')
  end
end
