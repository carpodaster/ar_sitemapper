require "rails"
require 'sitemapper/loader'

module AegisNet
  module Sitemapper

    class Engine < Rails::Engine

      initializer 'ar_sitemapper.load_app_root' do |app|
        AegisNet::Sitemapper.sitemap_file ||= File.join(app.root, "config", "sitemaps.yml")
      end

    end

  end
end
