require 'test_helper'

class MapTest < ActiveSupport::TestCase

  test "should have custom setters" do
    obj = AegisNet::Sitemapper::Map.new
    [:changefreq, :loc, :priority].each { |attr|  assert obj.respond_to?(attr) }
  end
end
