#!/usr/bin/env ruby

require 'config/environment'
FileUtils.cp File.join(File.dirname(__FILE__), "templates", "sitemapper.rake"), File.join(RAILS_ROOT, "tasks")
FileUtils.cp File.join(File.dirname(__FILE__), "templates", "sitemaps.yml"), File.join(RAILS_ROOT, "config")
