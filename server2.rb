require 'bundler'

Bundler.require :default

class DalliBench < Sinatra::Base
  configure do
    disable :static
    disable :protection
  end

  get '/' do
    "Hello, world!\n".freeze
  end
end
