require 'test_helper'

describe AegisNet::Sitemapper do
  it 'stores its sitemap yaml config file' do
    AegisNet::Sitemapper.must_respond_to 'sitemap_file'
    AegisNet::Sitemapper.must_respond_to 'sitemap_file='
  end

  it 'can be configured with a block' do
    AegisNet::Sitemapper.must_respond_to 'configure'
    yielded_to = nil
    AegisNet::Sitemapper.configure do |config|
      yielded_to = config
    end
    yielded_to.must_equal AegisNet::Sitemapper
  end

  it 'can store the parsed config file' do
    AegisNet::Sitemapper.must_respond_to 'configuration'
    AegisNet::Sitemapper.must_respond_to 'configuration='
  end
end
