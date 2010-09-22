module AegisNet # :nodoc:
  module Sitemapper # :nodoc:
    # :doc:
    
   class Urlset < AegisNet::Sitemapper::Sitemap

      def create!
        xml = Builder::XmlMarkup.new(:indent => 2)
        xml.instruct!

        xml.urlset "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9" do

          @sitemaps.each do |sitemap|
            location = sitemap.loc.gsub(/^\//, '')
            xml.url do
              xml.loc         "http://#{@host}/#{location}"
              xml.lastmod     sitemap.lastmod if sitemap.lastmod
              xml.changefreq  sitemap.changefreq
              xml.priority    sitemap.priority
            end
          end

        end
        File.open(@file, "w") { |file| file.puts xml.target! }
      end

      # Short-hand for Urlset#new and Urlset#create!
      def self.create!(options = {})
        sitemap = self.new(options)
        sitemap.create!
      end

      def self.build_all!
        config = AegisNet::Sitemapper::Loader.load_config

        # Generate sitemaps for AR Models dynamically by yml instructions
        if config[:models]
          config[:models].each do |ar_map|
            opts  = ar_map.last
            klass = ar_map.first.camelize.constantize

            build_opts = { :file => File.join("#{config[:local_path]}", opts["sitemapfile"]) }
            build_opts.merge!( :conditions => opts["conditions"])  if opts["conditions"]

            klass.build_sitemap :all, build_opts do |object, xml|
              xml.loc        eval(opts["loc"].gsub(/^eval:/, '').gsub(/:object/, "object"))
              xml.lastmod    object.updated_at.to_date
              xml.changefreq opts["changefreq"] || "weekly"
              xml.priority   opts["priority"] || 0.5
            end
          end
        end

        # Find misc. sitemap data and generate a single static one
        if config[:static]
          entries = config[:static]["urlset"]
          file    = File.join("#{config[:local_path]}", config[:static]["sitemapfile"])
          AegisNet::Sitemapper::Generator.create(entries, :file => file) do |entry, xml|
            xml.loc        entry["loc"]
            xml.lastmod    entry["lastmod"] if entry["lastmod"]
            xml.changefreq entry["changefreq"] if entry["changefreq"]
            xml.priority   entry["priority"] || 0.5
          end
        end

      end
    end
  end
end