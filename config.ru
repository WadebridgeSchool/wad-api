require 'bundler/setup'
Bundler.require

$LOAD_PATH.unshift File.expand_path('lib')

Mongoid.load! File.join('config', 'mongoid.yml')

require 'wiki/api'

run Wiki::API
