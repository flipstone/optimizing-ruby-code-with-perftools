env = ENV['PERFTOOLS_TALK_ENV'] || 'development'
Bundler.require
ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => "db/#{env}.db")

require_relative 'lib/schema'
Schema.create
require_relative 'lib/organization'
require_relative 'lib/investment'
require_relative 'lib/view'
require_relative 'lib/sample_data'
