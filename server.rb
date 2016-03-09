#!/usr/bin/env RACK_ENV=production ruby

require 'bundler/inline'

gemfile(true) do
  source 'https://rubygems.org'

  gem 'connection_pool'
  gem 'dalli', require: 'rack/session/dalli',
    git: 'https://github.com/mwpastore/dalli.git', branch: 'rack-session'
  gem 'puma', require: false
  gem 'sinatra', require: 'sinatra/base'
end

class DalliBench < Sinatra::Base
  configure do
    set :server, :puma

    disable :static
    disable :protection
  end

  use Rack::Session::Dalli,
    pool_size: 16,
    renew: true

  get '/' do
    session[:name] ||= params[:name] || 'world'
    "Hello, #{session[:name]}!\n"
  end

  run! if $0 == __FILE__
end
