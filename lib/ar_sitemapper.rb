module AegisNet
  module Sitemapper

    module ActiveRecordBuilder
      def self.included(base)
        base.extend SingletonMethods
      end

      module SingletonMethods
        def build_sitemap finder, options = {}
          raise(ArgumentError, "Unknown ActiveRecord finder: #{finder}") unless [:all, :first, :last].include?(finder.to_sym)
          valid_find_options = [ :conditions, :include, :joins, :limit, :offset,
                                 :order, :select, :group, :having, :from ]
          options = options.symbolize_keys!
          options.assert_valid_keys(Generator::VALID_GENERATOR_OPTIONS, valid_find_options)

          find_options = options.reject{|pair| !valid_find_options.include?(pair.first) }
          sitemap_opts = options.delete_if{|k, v| find_options.keys.include?(k)}
          entries = self.find(finder, find_options).to_a # get an array for :first and :last, too
          Generator.create(entries, sitemap_opts) { |entry, xml|  yield entry, xml }
        end
      end
    end

    class Generator

      VALID_GENERATOR_OPTIONS = [:filename, :gzip, :xmlns]

      def self.create entries, options = {}
        if block_given?
          options.symbolize_keys!
          options.assert_valid_keys(VALID_GENERATOR_OPTIONS)
          xmlns    = options[:xmlns] || "http://www.sitemaps.org/schemas/sitemap/0.9"
          gzip     = options[:gzip]  ||  /\.gz$/.match(options[:filename])
          filename = options[:filename] ? options[:filename].gsub(/\.gz$/, '') : nil

          xml = Builder::XmlMarkup.new(:indent => 2)
          xml.instruct!
          xml.urlset "xmlns" => xmlns do
            entries.each do |entry|
              xml.url { yield entry, xml }
            end
          end

          # Either write to file or to stdout
          if filename
            File.open(filename, "w") { |file| file.puts xml.target! }
          else
            $stdout.puts xml.target!
          end

          # GZip stuff?
          system("gzip --force #{filename}") if filename and gzip
        end
      end
    end

  end
end