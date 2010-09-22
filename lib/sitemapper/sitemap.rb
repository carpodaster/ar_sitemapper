module AegisNet # :nodoc:
  module Sitemapper # :nodoc:
    # :doc:
    class Sitemap
      attr_reader :lastmod, :loc

      def initialize(options = {})
        options.symbolize_keys!
        options.assert_valid_keys(:changefreq, :lastmod, :loc, :priority)
        @changefreq = options[:changefreq] || "weekly"
        @lastmod    = options[:lastmod]
        @loc        = options[:loc]
        @priority   = options[:priority] || 0.5
      end

      def changefreq(freq = nil); freq ? @changefreq = freq : @changefreq;  end
      def lastmod(lastmod = nil); lastmod ? @lastmod = lastmod : @lastmod; end
      def loc(loc = nil); loc ? @loc = loc : @loc; end
      def priority(prio = nil); prio ? @priority = prio : @priority; end
    end
  end
end