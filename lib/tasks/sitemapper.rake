# encoding: utf-8
namespace :sitemapper do

  desc "Rebuilds all sitemaps"
  task :rebuild => [:environment, :build_from_config]

  desc "Notifies search-engines about the index-sitemap"
  task :ping => :environment do
    ActiveRecord::Migration.say_with_time "Pinging searchengines" do
      AegisNet::Sitemapper::Pinger.ping!
    end
  end

  desc "Rebuild everything from config/sitemapper.yml"
  task :build_from_config => :environment do
    include Rails.application.routes.url_helpers
    config = AegisNet::Sitemapper::Loader.load_config
    default_url_options[:host] = config["default_host"]

    ActiveRecord::Migration.say_with_time "Rebuilding sitemaps from #{AegisNet::Sitemapper.sitemap_file}" do
      AegisNet::Sitemapper::Urlset.build_all!
      AegisNet::Sitemapper::Index.create!
    end
  end

end
