require 'bundler/setup'
require 'benchmark/ips'
require 'dalli'
require 'kgio'

$dalli = Dalli::Client.new nil,
  :namespace => 'test:rack:session'

# bad session ID passed in on rack.session cookie
# renew set to true

# 1. load_session calls get_session (aliased as find_session)
# 2. get_session calls dc.get, generate_sid_with(dc), and dc.add
# 3. generate_sid_with calls dc.get (reusing the connection)
# 4. commit_session calls destroy_session (aliased as delete_session)
#    and set_session (aliased as write_session)
# 5. destroy_session calls dc.delete and generate_sid_with(dc)
# 6. generate_sid_with calls dc.get (reusing the connection)
# 7. set_session calls dc.set

Benchmark.ips do |x|
  x.config(:time => 30, :warmup => 30)

  x.report('without with') do
    sid = '12345'

    $dalli.get(sid)

    sid = SecureRandom.hex(16)
    $dalli.get(sid)
    $dalli.add(sid, {}, 60)
    $dalli.delete(sid)

    sid = SecureRandom.hex(16)
    $dalli.get(sid)
    $dalli.set(sid, { :foo => 'bar' }, 60)
  end

  x.report('with') do
    sid = '12345'

    $dalli.with do |dc|
      dc.get(sid)

      sid = SecureRandom.hex(16)
      dc.get(sid)
      dc.add(sid, {}, 60)
    end

    $dalli.with do |dc|
      dc.delete(sid)

      sid = SecureRandom.hex(16)
      dc.get(sid)
    end

    $dalli.with do |dc|
      dc.set(sid, { :foo => 'bar' }, 60)
    end
  end
end
