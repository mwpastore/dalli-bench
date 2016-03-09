#!/usr/bin/env RACK_ENV=production ruby

require 'bundler'

Bundler.require :default

class DalliBench < Sinatra::Base
  configure do
    set :server, :puma

    disable :static
    disable :protection
  end

  use Rack::Session::Dalli,
    renew: true,
    memcache_server: '127.0.0.1:11211',
    expire_after: 60,
    pool_size: 20

  get '/' do
    session[:name] ||= params[:name] || 'world'.freeze
    "Hello, #{session[:name]}!\n"
  end

  run! if $0 == __FILE__
end
