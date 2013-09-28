# encoding: utf-8
namespace :sitemapper do

  desc "Rebuilds all sitemaps"
  task :rebuild => [:environment, :build_from_config, :build_kml]

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

    ActiveRecord::Migration.say_with_time "Rebuilding sitemaps from config/sitemapper.yml" do
      AegisNet::Sitemapper::Urlset.build_all!
      AegisNet::Sitemapper::Index.create!
    end
  end

  desc "Build KML file"
  task :build_kml => :environment do
    include Rails.application.routes.url_helpers
    config = AegisNet::Sitemapper::Loader.load_config
    default_url_options[:host] = config["default_host"]

    ActiveRecord::Migration.say_with_time "Rebuilding KML sitemap" do
      options = {
        :file =>  File.join(config["local_path"], "sitemap_geo.kml"),
        :xmlns => "http://www.opengis.net/kml/2.2"
      }

     AegisNet::Sitemapper::Generator.create( ServiceProvider.find(:all, :include => [:category, :geo_location]), options ) do |entry, xml|
        xml.Placemark do
          if entry.title.present?
            xml.name entry.title
          else
            xml.name entry.name
          end
          xml.description "<p>Branchenbuch bei KAUPERTS Berlin</p>"
          xml.ExtendedData do
            xml.Data "name" => "Link" do
              xml.displayName "Link"
              xml.value service_provider_url(entry)
            end
            xml.Data "name" => "Kategorie" do
              xml.displayName "Kategorie"
              xml.value entry.category.plural_name
            end
          end
          xml.Point do
            xml.coordinates entry.geo_location.lng.to_s + "," + entry.geo_location.lat.to_s + ",0"
          end
        end
      end

      `zip #{options[:file].gsub(/kml$/, 'kmz')} #{options[:file]} > /dev/null`

    end
  end

end
