AegisNet::Sitemapper::Index.draw do |sitemap|

  sitemap.add :loc => "foo", :changefreq => "weekly", :priority => 0.5
end

#
# Define static sitemaps
# AegisNet::Sitemapper::Map.new(