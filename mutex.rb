require 'bundler/setup'
require 'benchmark/ips'
require 'connection_pool'
require 'dalli'

THREAD_DEPTH = 400

$threadsafe = Dalli::Client.new nil,
  :namespace => 'test:rack:session',
  :threadsafe => true

$threaddangerous = Dalli::Client.new nil,
  :namespace => 'test:rack:session',
  :threadsafe => false

Benchmark.ips do |x|
  x.config(:time => 60, :warmup => 30)

  x.report('Dalli::Client') do
    key = '12345'.freeze
    value = 'foo'.freeze
    
    Array.new(THREAD_DEPTH) do
      Thread.new do
        $threadsafe.set(key, value)
        $threadsafe.get(key)
      end
    end.map(&:join)
  end

  x.report('Dalli::Client w/ Mutex') do
    key = '23456'.freeze
    value = 'bar'.freeze

    mutex = Mutex.new

    Array.new(THREAD_DEPTH) do
      Thread.new do
        mutex.lock
        $threaddangerous.set(key, value)
        mutex.unlock

        mutex.lock
        $threaddangerous.get(key)
        mutex.unlock
      end
    end.map(&:join)
  end
end
