#!/usr/bin/env ruby

require 'bundler/inline'

gemfile do
  gem 'json', :require => 'json/ext'
end

left = JSON.parse IO.read(ARGV.shift), :symbolize_names => true
right = JSON.parse IO.read(ARGV.shift), :symbolize_names => true

left.each do |k, v|
  unless right.key? k
    puts "#{k} is missing"
  end
end

__END__

sum = {}
obj[:thread_profiles].each do |thread_profile|
  thread_profile[:methods].each do |method|
    id = method[:id].to_i
    sum[id] ||= { :name => method[:name] }
    method.keys.each do |key|
      next unless key.to_s =~ /_(?:calls|time)$/
      sum[id][key] ||= 0
      sum[id][key] += method[key]
    end
  end
end

require 'pp'
pp sum.sort_by { |k, v| v[:total_calls] }.reverse
