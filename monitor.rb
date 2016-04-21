require 'bundler/setup'
require 'benchmark/ips'
require 'monitor'

THREAD_DEPTH = 400

Benchmark.ips do |x|
  x.config(:time => 60, :warmup => 30)

  x.report('Monitor') do
    lock = Monitor.new
    count = 0

    Array.new(THREAD_DEPTH) do
      Thread.new do
        lock.enter
        count += 1
        lock.exit

        lock.enter
        count -= 1
        lock.exit
      end
    end.map(&:join)
  end

  x.report('Mutex') do
    mutex = Mutex.new
    count = 0

    Array.new(THREAD_DEPTH) do
      Thread.new do
        mutex.lock
        count += 1
        mutex.unlock

        mutex.lock
        count -= 1
        mutex.unlock
      end
    end.map(&:join)
  end
end
