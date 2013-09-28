namespace :sitemapper do

  desc "Notifies search-engines about the index-sitemap"
  task :ping => :environment do
    ActiveRecord::Migration.say_with_time "Pinging searchengines" do
      AegisNet::Sitemapper::Pinger.ping!
    end
  end

  desc "Rebuild everything from config/sitemapper.yml"
  task :rebuild => :environment do
    ActiveRecord::Migration.say_with_time "Rebuilding sitemaps from config/sitemapper.yml" do
      AegisNet::Sitemapper::Urlset.build_all!
      AegisNet::Sitemapper::Index.create!
    end
  end

end
