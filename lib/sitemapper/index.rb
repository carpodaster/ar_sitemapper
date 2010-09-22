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

        @static = @config[:static]
        @models = @config[:models]

        # Validate all variables
        raise(ArgumentError, "No filename specified") if @file.nil?

        # Static Sitemap
        if @static
          sitemap_options = {:loc => @static["sitemapfile"], :lastmod => @static["lastmod"]}
          @sitemaps << AegisNet::Sitemapper::Urlset.new(sitemap_options)
        end

        @models.each do |sitemap|
          lastmod = sitemap.last["lastmod"] || sitemap.first.camelize.constantize.find(:last, :order => :updated_at).updated_at
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
              xml.lastmod     sitemap.lastmod.to_date if sitemap.lastmod
            end
          end
        end
        File.open(@file, "w") { |file| file.puts xml.target! }
      end
    end
    
  end
end