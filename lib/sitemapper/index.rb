module AegisNet # :nodoc:
  module Sitemapper # :nodoc:
    # :doc:

    class Index

      attr_reader :host, :sitemaps

      def initialize(options = {})
        options.symbolize_keys!
        @sitemaps = []

        @config = AegisNet::Sitemapper::Loader.load_config
        @host   = @config[:default_host]
        @file   = File.join("#{@config[:local_path]}", @config[:index]["sitemapfile"])

        @static   = @config[:static]
        @models   = @config[:models]
        @includes = @config[:index]["includes"]

        # Validate all variables
        raise(ArgumentError, "No filename specified") if @file.nil?

        # Static Sitemap
        if @static
          sitemap_options = {:loc => @static["sitemapfile"], :lastmod => @static["lastmod"]}
          @sitemaps << AegisNet::Sitemapper::Urlset.new(sitemap_options)
        end

        # Include additional sitemaps
        @includes.each do |sitemap|
          sitemap_options = {:loc => sitemap["loc"] }
          sitemap_options.merge!(:lastmod => sitemap["lastmod"]) if sitemap["lastmod"]
          @sitemaps << AegisNet::Sitemapper::Sitemap.new(sitemap_options)
        end

        @models.each do |sitemap|
          order_opts = {}
          order_opts = { :order => :created_at } if sitemap.first.camelize.constantize.column_names.include?("created_at")
          lastmod = sitemap.last["lastmod"] || sitemap.first.camelize.constantize.last(order_opts).created_at
          sitemap_options = {:loc => sitemap.last["sitemapfile"], :lastmod => lastmod}
          @sitemaps << AegisNet::Sitemapper::Urlset.new(sitemap_options)
        end

      end

      def self.create!(options = {})
        index = self.new(options)
        index.create!
      end

      def create!
        xml = Builder::XmlMarkup.new(:indent => 2)
        xml.instruct!

        xml.sitemapindex "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9" do

          @sitemaps.each do |sitemap|
            location = sitemap.loc.gsub(/^\//, '')
            xml.sitemap do
              xml.loc         "http://#{@host}/#{location}"
              xml.lastmod     sitemap.lastmod.to_date if sitemap.lastmod rescue nil # TODO handle properly
            end
          end
        end
        File.open(@file, "w") { |file| file.puts xml.target! }
      end
    end

  end
end
