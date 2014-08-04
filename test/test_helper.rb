ENV["RAILS_ENV"] ||= 'test'

require File.expand_path('../dummy/config/environment.rb', __FILE__)

require 'rubygems'
require 'bundler'
Bundler.require(:default, :development)

# Rails 4.1 introduced minitest 5.x which has some
# incompatibilities to the old 4.x API
old_minitest = Rails::VERSION::STRING < '4.1.0'

require (old_minitest ? 'test/unit' : 'minitest')
require 'minitest/autorun'

require 'erb'
require 'mocha/setup'

unless old_minitest
  module Test
    module Unit
      TestCase = Minitest::Test
    end
  end
end

Dir.glob(File.join(File.dirname(__FILE__) + 'support', 'app', '*') {|file| require file})
