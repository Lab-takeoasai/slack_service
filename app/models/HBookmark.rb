require 'feedjira'
require_relative '../helpers/record_establish'
require_relative '../helpers/slack_post'

class HBookmark < ActiveRecord::Base
  validates_uniqueness_of :url
  USERS = 1000


  def slack
    text = self.title + "\n" + self.url + "\n" + (self.summary.nil? ? "" : self.summary)
    slack_post(text, "Hatena bookmark", "#general")

    self.slacked = true
    save
  end

  # class method
  def self.stockByTag(tag)
    uri = URI.encode("http://b.hatena.ne.jp/search/tag?q=#{tag}&users=#{USERS}&of=0&mode=rss")
    feed = Feedjira::Feed.fetch_and_parse(uri)
    for e in feed.entries
      HBookmark.create(url: e.url, title: e.title, summary: e.summary, published: e.published, slacked: false)
    end
  end

  def self.unslacked
    HBookmark.where(:slacked => false)
  end
end
