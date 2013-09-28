require 'test_helper'
require 'minitest/autorun'

describe AegisNet::Sitemapper::Loader do

  it 'returns its default config path' do
    AegisNet::Sitemapper::Loader::CONFIG_FILE.must_equal "#{Rails.root}/config/sitemaps.yml"
  end

  it 'loads the default config' do
    config = AegisNet::Sitemapper::Loader.load_config
    config.wont_be_nil
    config.must_be_kind_of HashWithIndifferentAccess
  end

  it 'returns a proc' do
    proc_eval = AegisNet::Sitemapper::Loader.proc_loader "Proc.new { 'foo' }"
    proc_eval.must_equal 'foo'

    proc_str = "Proc.new { |a,b| 'foo ' << a << ', bar ' << b}"
    proc_eval = AegisNet::Sitemapper::Loader.proc_loader(proc_str, "hello", "world")
    proc_eval.must_equal 'foo hello, bar world'
  end

end
