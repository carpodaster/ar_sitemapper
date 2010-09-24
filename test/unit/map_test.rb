require File.join File.dirname(__FILE__), '..', 'test_helper'

class MapTest < Test::Unit::TestCase

  def test_should_have_custom_setters
    obj = AegisNet::Sitemapper::Sitemap.new
    [:changefreq, :loc, :priority].each { |attr|  assert_respond_to obj, attr }
  end
end
