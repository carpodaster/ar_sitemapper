require 'test_helper'

describe AegisNet::Sitemapper::Loader do

  it 'loads and stores the default config' do
    config = AegisNet::Sitemapper::Loader.load_config
    config.wont_be_nil
    config.must_be_kind_of HashWithIndifferentAccess
    AegisNet::Sitemapper.configuration.must_equal config
  end

  it 'returns a proc' do
    proc_eval = AegisNet::Sitemapper::Loader.proc_loader "Proc.new { 'foo' }"
    proc_eval.must_equal 'foo'

    proc_str = "Proc.new { |a,b| 'foo ' << a << ', bar ' << b}"
    proc_eval = AegisNet::Sitemapper::Loader.proc_loader(proc_str, "hello", "world")
    proc_eval.must_equal 'foo hello, bar world'
  end

end
