require 'sitemapper/loader'

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
        # Rails.root/public/sitemap_modelnames.xml.gz by default. Set +:filename+
        # to +nil+ or +false+ explicitely if you don't want the filename to be
        # guessed (ie. if you want output to stdout).
        #
        # === Parameters
        # * +scope+: :all, :first, :last or a named scope
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
        def build_sitemap scope, options = {}
          scope = scope.to_sym
          raise(ArgumentError, "Unknown ActiveRecord finder: #{scope}") unless self.respond_to?(scope)
          valid_find_options = [ :conditions, :include, :joins, :limit, :offset,
                                 :order, :select, :group, :having, :from ]
          options = options.symbolize_keys!
          options.assert_valid_keys(Generator::VALID_GENERATOR_OPTIONS, valid_find_options)

          find_options = options.reject{|pair| !valid_find_options.include?(pair.first) }
          sitemap_opts = options.delete_if{|k, v| find_options.keys.include?(k)}

          # Extra treatment for the filename option
          sitemap_opts[:file] = sitemap_opts.keys.include?(:file) ? sitemap_opts[:file] : AegisNet::Sitemapper::Generator.default_filename(self.class)

          entries = self.send(scope, find_options).to_a # get an array for :first and :last, too
          AegisNet::Sitemapper::Generator.create(entries, sitemap_opts) { |entry, xml|  yield entry, xml }
        end
      end
    end
  end
end
