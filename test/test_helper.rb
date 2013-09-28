ENV["RAILS_ENV"] ||= 'test'

require File.expand_path('../dummy/config/environment.rb', __FILE__)

require 'test/unit'
require 'rubygems'
require 'mocha'
require 'active_support/core_ext'

require 'erb'

require 'lib/ar_sitemapper'
Dir.glob(File.join(File.dirname(__FILE__) + 'support', 'app', '*') {|file| require file})
