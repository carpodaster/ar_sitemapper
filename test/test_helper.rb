RAILS_ROOT = File.join(File.dirname(__FILE__), 'support')
puts RAILS_ROOT

require 'test/unit'
require 'rubygems'
require 'mocha'
require 'active_support/core_ext'

require 'erb'

require 'lib/ar_sitemapper'
Dir.glob(File.join(File.dirname(__FILE__) + 'support', 'app', '*') {|file| require file})
