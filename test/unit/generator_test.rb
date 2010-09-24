require File.join File.dirname(__FILE__), '..', 'test_helper'

class GeneratorTest < Test::Unit::TestCase

  def test_should_return_valid_configure_options
    assert_equal [:file, :filename, :gzip, :xmlns].map(&:to_s).sort, AegisNet::Sitemapper::Generator::VALID_GENERATOR_OPTIONS.map(&:to_s).sort
  end

  def test_should_return_default_filename
    config = AegisNet::Sitemapper::Loader.load_config
    assert_equal "#{config[:local_path]}/sitemap_some_classes.xml.gz", AegisNet::Sitemapper::Generator::default_filename("SomeClass")
  end

end
