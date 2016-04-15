#!/usr/bin/env ruby

require 'bundler/inline'

gemfile do
  gem 'json', :require => 'json/ext'
end

require 'json/ext'

obj = JSON.parse ARGF.read, :symbolize_names => true

sum = {}
obj[:thread_profiles].each do |thread_profile|
  thread_profile[:methods].each do |method|
    name = method[:name]
    sum[name] ||= { :id => method[:id].to_i }

    method.keys.each do |key|
      next unless key.to_s =~ /_(?:calls|time)$/
      sum[name][key] ||= 0
      sum[name][key] += method[key]
    end
  end
end

print JSON.pretty_generate sum
  .select { |k, v| v[:total_calls] > 1 && v[:self_time] > 30 }
  .sort_by { |k, _| k }
  .to_h
