require "rails"
require 'sitemapper/loader'

module AegisNet
  module Sitemapper

    class Engine < Rails::Engine

      initializer 'ar_sitemapper.load_app_root' do |app|
        AegisNet::Sitemapper.sitemap_file ||= File.join(app.root, "config", "sitemaps.yml")
      end

      initializer 'ar_sitemapper.hook_into_active_record' do
        ActiveSupport.on_load(:active_record) do
          ::ActiveRecord::Base.send :include, AegisNet::Sitemapper::ActiveRecord::Builder
        end
      end

    end

  end
end
