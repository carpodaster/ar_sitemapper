require File.dirname(__FILE__) + '/../test_helper'

class UrlsetTest < Test::Unit::TestCase

  def test_should_extend_sitemap
    assert AegisNet::Sitemapper::Urlset.new.is_a? AegisNet::Sitemapper::Sitemap
  end

end
