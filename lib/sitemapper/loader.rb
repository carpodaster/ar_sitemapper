require 'sitemapper/sitemap'
require 'sitemapper/urlset'
require 'sitemapper/index'
require 'sitemapper/pinger'

module AegisNet
  module Sitemapper

    class Loader
      CONFIG_FILE = File.join(RAILS_ROOT, "config", "sitemaps.yml")
      # Loads the sitemap configuration from RAILS_ROOT/config/sitemap.yml
      def self.load_config
        # TODO verify file integrity
        erb = ERB.new(File.read(CONFIG_FILE))
        $sitemapper_config ||= HashWithIndifferentAccess.new(YAML.load(StringIO.new(erb.result)))
      end
    end
  end
end
