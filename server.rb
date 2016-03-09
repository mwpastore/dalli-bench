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
    expire_after: 60,
    pool_size: 10

  get '/' do
    session[:name] ||= params[:name] || 'world'
    "Hello, #{session[:name]}!\n"
  end

  run! if $0 == __FILE__
end
