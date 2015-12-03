require 'test_helper'

class PingerTest < Test::Unit::TestCase

  def test_should_ping_remote_host
    config = AegisNet::Sitemapper::Loader.load_config
    assert config[:pings].any?
    stub_request(:get, "http://ping.example.com/ping?sitemap=www.example.com/sitemap_index.xml")
    AegisNet::Sitemapper::Pinger.ping!
  end
end
