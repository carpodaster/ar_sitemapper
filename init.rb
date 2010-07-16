require 'ar_sitemapper'
ActiveRecord::Base.send(:include, AegisNet::Sitemapper::ActiveRecordBuilder)
