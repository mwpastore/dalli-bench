require 'bundler'

Bundler.require :default

class DalliBench < Sinatra::Base
  configure do
    set :server, :puma

    disable :static
    disable :protection
  end

  use Rack::Session::Dalli,
    pool_size: 256,
    renew: true

  get '/' do
    session[:name] ||= params[:name] || 'world'
    "Hello, #{session[:name]}!\n"
  end

  run! if $0 == __FILE__
end
