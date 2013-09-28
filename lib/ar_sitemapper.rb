require 'rails'
require 'sitemapper/loader'

module AegisNet
  module Sitemapper
    mattr_accessor :sitemap_file

    def self.configure
      yield self if block_given?
    end
  end
end
