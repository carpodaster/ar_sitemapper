# ActiveRecord Sitemapper [![Build Status](https://travis-ci.org/carpodaster/ar_sitemapper.svg?branch=master)](https://travis-ci.org/carpodaster/ar_sitemapper)
## Low-level sitemap-building

The standard approach to generate XML sitemaps for a Ruby on Rails application
seems to be creating a special SitemapsController with xml views and a bit
of routes.rb magic.

I used to generate sitemaps created thus via a nightly rake task to have them
cached and delivered statically by Apache. That felt wrong, I wanted a more
"low-level" approach. Actually, as low-level as possible and I ended up at
ActiveRecord::Base: this plugin enhances your ActiveRecord model to export
its data to a sitemap in an intuitive way.

Also yes, I know there are probably a gazillion projects covering this already.

## Installation

To add **ar_sitemapper** to your Rails 3 project, add it to your Gemfile:

```
gem 'ar_sitemapper', '~> 1.0.0'
```

## Usage

### ActiveRecord drop-in

You can use `build_sitemap` directly on any ActiveRecord model. The following
example will create a sitemap of all your Content objects as Rails.root/public/sitemap_contents.xml.gz:

```ruby
Content.build_sitemap :all do |content, xml|
  xml.loc content_url(content)
  xml.changefreq 'weekly'
  xml.lastmod content.updated_at.strftime("%Y-%m-%d")
  xml.priority 0.5
end
```

You can pass ActiveRecord::Base.find options as arguments to `build_sitemap`
to fine-tune the selection of objects you want to extract:

```ruby
Post.build_sitemap :all, :conditions => ["published IS TRUE"], :order => :name do |post, xml|
  # do stuff here
end
```

**Note**: if you want to use your named route helpers in the block, be sure to have
ActionController::UrlWriter included. Setting default_url_options[:host]
is helpful, too.

### Output

**ar_sitemapper** will derive its sitemap filename from the model's name and will
default to Gzip compressed output. If can write to `stdout` as well if `file`
is explicitely set to `nil` or `false`.

It will automatically compress your XML sitemap with Gzip if the filename parameter suggests it (ie. ends with ".gz"). Alternatively, you can enforce or disable Gzip compression by passing true or false to the `gzip` option.

Both of the following examples will create a gzip'ed file named "test.xml.gz":

```ruby
Content.build_sitemap :all, :file => "test.xml.gz" { |content, xml| ... }
Content.build_sitemap :all, :file => "test.xml", :gzip => true { |content, xml| ... }
```

### Sitemaps for static data

Sitemap creation is done via a block, so you can do whatever you want in it. For added flexibility, you can use **ar_sitemapper** with arbitrary data collections (ie. generating sitemaps for static content). Future versions will support YAML configuration of such static content.

```ruby
sites = [
  { :url => "http://example.com/your/static/content1.html", :freq => "always",  :prio => "1.0" },
  { :url => "http://example.com/your/static/content2.html", :freq => "monthly", :prio => "0.3" },
]

AegisNet::Sitemapper::Generator.create(sites) do |site, xml|
  xml.loc site[:url]
  xml.changefreq site[:freq]
  xml.priority site[:prio]
end
```

### YAML configuration
Sitemapper supports configuration via a YAML file which is expected to reside in `Rails.root/config/sitemaps.yml`.

#### Supported top level configuration options
* **default_host**: base hostname used for url generation (mandatory).
* **local_path**: where to store the generated sitemaps on the local system (mandatory).
* **ping**: boolean whether or not to ping search engines on successful sitemap generation.
* **index**: options for the main sitemap index file, ie. the file that references all others.
* **static**: options for the sitemap that lists URLs to static content (ie. URLs not
  necessarily related to AR models)
* **models**: options for model-related URLset sitemaps
* **ping**: a list of search engines' ping services.

#### The `index` option
* **sitemapfile**: the name of the the generated sitemap.
* **includes**: an array of sitemaps that should be included in the sitemap index but
  are _not_ generated directly through AR:Sitemapper (eg. a KML-sitemap).

#### The `static` option
* **sitemapfile**: the name of the the generated sitemap.
* **urlset**: a list of static pages to include into the sitemap. Every item must
  have a **loc** element. A `changefreq` and `priority` element is optional and defaults to _weekly_ and _0.5_, respectively.

#### The `model` option
A list of models to create sitemaps for. The key must be the downcased und
underscored name of the model. Supported / required options for every model-based
sitemap are:
* **sitemapfile**: the name of the the generated sitemap (mandatory).
* **loc**: a Proc definition to generate the URLs for each object with (mandatory).
* **changefreq**: optional, defaults to 'weekly'
* **priority**: optional, defaults to '0.5'
* **lastmod**: you can use ERB to insert the date you desire.
* **conditions**: conditions to be merged into the finder of `build_sitemap` (optional).
* **scope**: a named scope to find objects with

#### Sample YAML file

```yaml
default_host: "www.example.com"
local_path: <%= File.join Rails.root, "public", "sitemaps" %>
ping: true
index:
  sitemapfile: "sitemap_index.xml"
  includes:
    -
      loc: some_other_sitemap.xml
static:
  sitemapfile: "sitemap_static.xml.gz"
  urlset:
    -
      loc: "http://www.example.com/static/content"
      changefreq: weekly
      priority: 1.0
    -
      loc: "http://www.example.com/another/page"
      changefreq: weekly
      priority: 1.0
models:
  foo_bar:
    sitemapfile: sitemap_foo_bars.xml.gz
    lastmod: <%= 2.days.ago %>
    loc: Proc.new {|object| foo_bar_path(object) }
    changefreq: weekly
    priority: 0.7
    conditions: "foo > 1"
  acme:
    sitemapfile: sitemap_proctests.xml.gz
    scope: liquid
    lastmod: <%= Acme.find(:last, :order => :updated_at).updated_at %>
    loc: Proc.new {|object| acme_path(object) }
    changefreq: weekly
    priority: 0.8
pings:
  - http://submissions.ask.com/ping?sitemap=
  - http://www.google.com/webmasters/sitemaps/ping?sitemap=
  - http://search.yahooapis.com/SiteExplorerService/V1/updateNotification?appid=YahooDemo&url=
  - http://www.bing.com/webmaster/ping.aspx?siteMap=
```

### Rake task
The gem provides a rake task to rebuild all sitemaps from its config file:

```
rake sitemapper:rebuild
```

## .plan
* support KML files
* allow for a custom iterator supplied as Proc for Generator::create (ie. to make use of ARs batch finding)
* cleanup
* more flexible syntax for conditions in yml file
* guess RESTful object path and make Proc object for loc in models optional
* Install a sample sitemap.yml file

---

Copyright (c) 2010-2013 Carsten Zimmermann, released under a BSD-type license
