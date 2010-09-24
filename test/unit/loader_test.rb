require File.join File.dirname(__FILE__), '..', 'test_helper'

class LoaderTest < Test::Unit::TestCase

  def test_should_return_default_config_path
    assert_equal "#{RAILS_ROOT}/config/sitemaps.yml", AegisNet::Sitemapper::Loader::CONFIG_FILE
  end

  def test_should_load_default_config
    config = AegisNet::Sitemapper::Loader.load_config
    assert_not_nil config
    assert config.is_a?(HashWithIndifferentAccess), config.inspect
  end

  def test_should_return_proc
    proc_eval = AegisNet::Sitemapper::Loader.proc_loader "Proc.new { 'foo' }"
    assert_equal 'foo', proc_eval

    proc_str = "Proc.new { |a,b| 'foo ' << a << ', bar ' << b}"
    proc_eval = AegisNet::Sitemapper::Loader.proc_loader(proc_str, "hello", "world")
    assert_equal 'foo hello, bar world', proc_eval
  end

end
