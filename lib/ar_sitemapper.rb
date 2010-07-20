module AegisNet
  module Sitemapper

    module ActiveRecordBuilder
      def self.included(base)
        base.extend SingletonMethods
      end

      module SingletonMethods

        # Adds sitemap building functionality to ActiveRecord models.
        #
        # The option +:filename+ is derived from the model name and will be set to
        # RAILS_ROOT/public/sitemap_modelnames.xml.gz by default. Set +:filename+
        # to +nil+ or +false+ explicitely if you don't want the filename to be
        # guessed (ie. if you want output to stdout).
        #
        # === Parameters
        # * +finder+: one of :all, :first or :last
        # * +options+: a Hash with options to pass to ActiveRecord::Base.find and AegisNet::Sitemapper::Generator
        #
        # === Supported Options
        # * see AegisNet::Sitemapper::Generator::VALID_GENERATOR_OPTIONS
        #
        # === Example
        #  Content.build_sitemap :all, :file => "sitemap_content.xml" do |content, xml|
        #    xml.loc content_path(content)
        #    xml.changefreq "weekly"
        #    xml.priority 0.5
        #  end
        #
        def build_sitemap finder, options = {}
          raise(ArgumentError, "Unknown ActiveRecord finder: #{finder}") unless [:all, :first, :last].include?(finder.to_sym)
          valid_find_options = [ :conditions, :include, :joins, :limit, :offset,
                                 :order, :select, :group, :having, :from ]
          options = options.symbolize_keys!
          options.assert_valid_keys(Generator::VALID_GENERATOR_OPTIONS, valid_find_options)

          find_options = options.reject{|pair| !valid_find_options.include?(pair.first) }
          sitemap_opts = options.delete_if{|k, v| find_options.keys.include?(k)}
          
          # Extra treatment for the filename option
          sitemap_options[:file] = sitemap_options.keys.include?(:file) ? sitemap_options[:file] : File.join(RAILS_ROOT, "public", "sitemap_#{self.class.to_s.underscore.pluralize}.xml.gz")

          entries = self.find(finder, find_options).to_a # get an array for :first and :last, too
          AegisNet::Sitemapper::Generator.create(entries, sitemap_opts) { |entry, xml|  yield entry, xml }
        end
      end
    end

    class Generator

      require "zlib"

      VALID_GENERATOR_OPTIONS = [:file, :filename, :gzip, :xmlns]

      # Generates an XML Sitemap file with +entries+. The output is written
      # to a file if a filename is given or to stdout otherwise. Expects a
      # block.
      #
      # === Parameters
      # * +entries+: Enumerable to iterate through
      # * +options+: an optional Hash. See below for supported options
      #
      # === Available Options
      # * +:file+: full path to output file. If +:filename+ ends with .gz, Gzip-compression is activated
      # * +:gzip+: force GZip compression if set to +true+
      # * +:xmlns+: XML namespace to use, defaults to http://www.sitemaps.org/schemas/sitemap/0.9
      #
      # === Example
      #  sites = [
      #    { :url => "http://example.com/your/static/content1.html", :freq => "always",  :prio => "1.0" },
      #    { :url => "http://example.com/your/static/content2.html", :freq => "monthly", :prio => "0.3" },
      #  ]
      #
      #  AegisNet::Sitemapper::Generator.create(sites) do |site, xml|
      #    xml.loc site[:url]
      #    xml.changefreq site[:freq]
      #    xml.priority site[:prio]
      #  end
      #
      def self.create entries, options = {}
        if block_given?
          options.symbolize_keys!
          options.assert_valid_keys(VALID_GENERATOR_OPTIONS)
          xmlns    = options[:xmlns] || "http://www.sitemaps.org/schemas/sitemap/0.9"
          gzip     = options[:gzip]  ||  /\.gz$/.match(options[:file])
          filename = options[:file] ? options[:file].gsub(/\.gz$/, '') : nil

          xml = Builder::XmlMarkup.new(:indent => 2)
          xml.instruct!
          xml.urlset "xmlns" => xmlns do
            entries.each do |entry|
              xml.url { yield entry, xml }
            end
          end

          # Either write to file or to stdout
          if filename
            if gzip
              Zlib::GzipWriter.open {|gz| gz.write xml.target! }
            else
              File.open(filename, "w") { |file| file.puts xml.target! }
            end
          else
            $stdout.puts xml.target!
          end
        end
      end
    end

  end
end