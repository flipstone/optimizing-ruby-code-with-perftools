#!/usr/bin/env ruby
#
require 'bundler'
Bundler.setup
require 'optparse'

require_relative '../boot'

STATISTICS_RENDER_COUNT = 100

timing = false
profiling = false

OptionParser.new do |opts|
  opts.banner = "Usage: ./bin/render.rb [options]"
  opts.on("--time", "Gather timing statistics for render") do |t|
    timing = t
  end

  opts.on("--profile", "Gather profiling statistics for render") do |p|
    profiling = p
  end
end.parse!

SampleData.create

def render_and_write_to_file
  File.open 'tmp/output.html', 'w' do |io|
    io.write View.render
  end
end

if !(timing || profiling)
  render_and_write_to_file
else
  if timing
    start = Time.now
  end

  if profiling
    require 'perftools'
    PerfTools::CpuProfiler.start("tmp/profile")
  end

  STATISTICS_RENDER_COUNT.times { View.render }

  if timing
    stop = Time.now
    puts "Total time for #{STATISTICS_RENDER_COUNT} renders: #{stop - start} seconds"
  end

  if profiling
    PerfTools::CpuProfiler.stop
    command = "bundle exec pprof.rb --gif tmp/profile > tmp/profile.gif"
    system(command) || raise("PerfTools command failed: #{command}")
    puts "Created profiling report at tmp/profile.gif"
   end
end

