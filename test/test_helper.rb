ENV["RAILS_ENV"] ||= 'test'

require File.expand_path('../dummy/config/environment.rb', __FILE__)

require 'test/unit'
require 'minitest/autorun'
require 'rubygems'
require 'bundler'
Bundler.require(:default, :development)

require 'erb'
require 'mocha/setup'

Dir.glob(File.join(File.dirname(__FILE__) + 'support', 'app', '*') {|file| require file})
