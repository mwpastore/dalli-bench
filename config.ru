require 'bundler'
Bundler.require :default
require_relative 'app'

use Rack::Session::Dalli,
  renew: true,
  memcache_server: '127.0.0.1:11211',
  expire_after: 60,
  pool_size: ENV.fetch('THREAD_DEPTH').to_i

run DalliBench
