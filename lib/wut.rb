# frozen_string_literal: true

require 'roda'
require_relative 'tracker'

# Wut App principal class
class WutApp < Roda
  # not_found do
  #   slim :error, layout: false, logic_less: false
  # end

  route do |r|
    r.is '/' do
      # slim :index
      @warez = Tracker.new.warez
    end

    r.is 'reload' do
      Tracker.new.reload and redirect('/')
    end
  end
end
