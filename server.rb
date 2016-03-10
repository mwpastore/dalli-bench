require 'bundler'

Bundler.require :default

class DalliBench < Sinatra::Base
  configure do
    disable :static
    disable :protection
  end

  use Rack::Session::Dalli,
    renew: true,
    memcache_server: '127.0.0.1:11211',
    expire_after: 60,
    pool_size: ENV.fetch('THREAD_DEPTH')

  get '/' do
    session[:name] ||= params[:name] || 'world'.freeze
    "Hello, #{session[:name]}!\n"
  end
end
