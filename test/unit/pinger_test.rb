require 'test_helper'

class PingerTest < Test::Unit::TestCase

  def test_should_ping_remote_host
    config = AegisNet::Sitemapper::Loader.load_config
    pings = config[:pings]
    Net::HTTP.expects(:get_response).times(pings.size).returns(mock())
    AegisNet::Sitemapper::Pinger.ping!
  end
end
