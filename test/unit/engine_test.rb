require 'test_helper'

describe AegisNet::Sitemapper::Engine do

  it 'returns sets the default config path' do
    AegisNet::Sitemapper.sitemap_file.must_equal "#{Rails.root}/config/sitemaps.yml"
  end

end
