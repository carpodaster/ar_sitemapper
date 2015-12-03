module AegisNet # :nodoc:
  module Sitemapper # :nodoc:
    # :doc:

    class Pinger

      require "net/http"

      def self.ping!
        config = AegisNet::Sitemapper::Loader.load_config
        if config[:ping] and config[:default_host] and config[:index]
          config[:pings].each do |ping_url|
            url = ping_url + config[:default_host] + "/" + config[:index]["sitemapfile"]
            Net::HTTP.get_response(URI.parse(url)) rescue nil
          end
        end
      end

    end
  end
end
