require 'sitemapper/generator'
require 'sitemapper/sitemap'
require 'sitemapper/urlset'
require 'sitemapper/index'
require 'sitemapper/pinger'
require 'sitemapper/active_record/builder'

module AegisNet
  module Sitemapper

    class Loader
      # Loads the sitemap configuration from Rails.root/config/sitemap.yml
      def self.load_config
        # TODO verify file integrity
        erb = ERB.new(File.read(AegisNet::Sitemapper.sitemap_file))
        $sitemapper_config ||= HashWithIndifferentAccess.new(YAML.load(StringIO.new(erb.result)))
      end

      # Interprets +string+ as Ruby code representing a Proc and exectutes it.
      #
      # === Parameters
      # * +string+: Ruby (Proc) code to be executed
      # All other arguments will be passed to the Proc
      #
      # === Examples
      #  AegisNet::Sitemapper::Loader.proc_loader('Proc.new{"foo"}')
      #  => "foo"
      #
      #  proc_str = 'Proc.new{|n| n}'
      #  AegisNet::Sitemapper::Loader.proc_loader(proc_str, "hello world")
      #  => "hello world"
      def self.proc_loader(string, *args)
        # TODO lambdas
        eval(string).call(*args)
      end

    end
  end
end
