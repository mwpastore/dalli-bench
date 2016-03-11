#!/usr/bin/env ruby

ENV['THREAD_DEPTH'] = '16'
ENV['RACK_ENV'] = 'production'

require_relative 'server2'

env =
{"rack.version"=>[1, 3],
 "rack.errors"=>nil,
 "rack.multithread"=>true,
 "rack.multiprocess"=>false,
 "rack.run_once"=>false,
 "SCRIPT_NAME"=>"",
 "QUERY_STRING"=>"",
 "SERVER_PROTOCOL"=>"HTTP/1.1",
 "SERVER_SOFTWARE"=>"3.1.0",
 "GATEWAY_INTERFACE"=>"CGI/1.2",
 "REQUEST_METHOD"=>"GET",
 "REQUEST_PATH"=>"/",
 "REQUEST_URI"=>"/",
 "HTTP_VERSION"=>"HTTP/1.1",
 "HTTP_USER_AGENT"=>"curl/7.35.0",
 "HTTP_HOST"=>"localhost:9292",
 "HTTP_ACCEPT"=>"*/*",
 "SERVER_NAME"=>"localhost",
 "SERVER_PORT"=>"9292",
 "PATH_INFO"=>"/",
 "REMOTE_ADDR"=>"0:0:0:0:0:0:0:1",
 "rack.hijack?"=>false,
 "rack.input"=>StringIO.new,
 "rack.url_scheme"=>"http",
 "rack.after_reply"=>[],
 "rack.logger"=>nil,
 "rack.session"=>nil,
 "rack.session.options"=>
  {:path=>"/",
   :domain=>nil,
   :expire_after=>60,
   :secure=>false,
   :httponly=>true,
   :defer=>false,
   :renew=>true,
   :sidbits=>128,
   :secure_random=>SecureRandom,
   :memcache_server=>"127.0.0.1:11211",
   :pool_size=>400},
 "rack.request.query_string"=>"",
 "rack.request.query_hash"=>{}}

#foo = DalliBench.new
#100_000.times { foo.call env }

100_000.times { DalliBench.call env }
