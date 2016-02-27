require 'feedjira'
require_relative '../helpers/record_establish'
require_relative '../helpers/slack_post'

# gets favorite Hatena bookmarks which are starred more than 1,000 times
class HBookmark < ActiveRecord::Base
  validates_uniqueness_of :url
  USERS = 1000
  HB_BASE_URL = 'http://b.hatena.ne.jp/search/'.freeze

  def slack
    text = title + "\n" + url + "\n" + (summary.nil? ? '' : summary)
    slack_post(text, 'Hatena bookmark', '#general')

    self.slacked = true
    save
  end

  # class method
  def self.stock_by_tag(tag)
    uri = URI.encode("#{HB_BASE_URL}tag?q=#{tag}&users=#{USERS}&of=0&mode=rss")
    Feedjira::Feed.fetch_and_parse(uri).entries.each do |e|
      HBookmark.create(
        url: e.url,
        title: e.title,
        summary: e.summary,
        published: e.published,
        slacked: false
      )
    end
  end

  def self.unslacked
    HBookmark.where(slacked: false)
  end
end
