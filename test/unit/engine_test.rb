require 'test_helper'

describe AegisNet::Sitemapper::Engine do

  it 'returns sets the default config path' do
    AegisNet::Sitemapper.sitemap_file.must_equal "#{Rails.root}/config/sitemaps.yml"
  end

  it 'integrates with ActiveRecord' do
    active_record_builder::SingletonMethods.instance_methods.each do |method|
      ActiveRecord::Base.must_respond_to method
    end
  end

  def active_record_builder
    AegisNet::Sitemapper::ActiveRecord::Builder
  end

end
