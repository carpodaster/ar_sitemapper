module AegisNet
  module Sitemapper
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
      def self.create entries, options = {}, &block
        if block_given?
          options.symbolize_keys!
          options.assert_valid_keys(VALID_GENERATOR_OPTIONS)
          xmlns    = options[:xmlns] || "http://www.sitemaps.org/schemas/sitemap/0.9"
          gzip     = options[:gzip]  ||  /\.gz$/.match(options[:file])
          filename = options[:file] ? options[:file].gsub(/\.gz$/, '') : nil

          if entries.size > 50_000
            part_number = 0
            entries.each_slice(50_000) do |part|
              part_number = part_number.next
              part_fn = filename.gsub('.xml', ".#{part_number}.xml")

              create_one_sitemap(part, xmlns, part_fn, gzip, &block)
            end
          else
            create_one_sitemap(entries, xmlns, filename, gzip, &block)
          end
        end
      end

      # Infer full local path and sitemap filename by class name. Adds .xml.gz
      #
      # === Parameters
      # * +klass+: class name
      def self.default_filename(klass)
        config = AegisNet::Sitemapper::Loader.load_config
        File.join(config[:local_path], "sitemap_#{klass.to_s.underscore.pluralize}.xml.gz") if config[:local_path]
      end

      def self.create_necessary_directories(filename)
        FileUtils.mkpath( File.dirname(filename) )
      end

      def self.create_one_sitemap(entries, xmlns, filename, gzip, &block)
        write_one_sitemap(
          generate_one_sitemap(entries, xmlns, &block),
          filename,
          gzip
        )
      end

      def self.generate_one_sitemap(entries, xmlns, &block)
        xml = Builder::XmlMarkup.new(:indent => 2)
        xml.instruct!
        xml.urlset "xmlns" => xmlns do
          entries.each do |entry|
            xml.url { block.call(entry, xml) } rescue nil # TODO handle me / pass upwards
          end
        end
        xml
      end

      def self.write_one_sitemap(xml, filename, gzip)
        # Either write to file or to stdout
        if filename
          create_necessary_directories(filename)
          File.open(filename, "w") { |file| file.puts xml.target! }
          Zlib::GzipWriter.open("#{filename}.gz") {|gz| gz.write xml.target! } if gzip
        else
          $stdout.puts xml.target!
        end
      end
    end
  end
end
