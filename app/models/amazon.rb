require 'amazon/ecs'
require 'dotenv'

Dotenv.load
Amazon::Ecs.configure do |options|
  options[:associate_tag] = 'isaid-22'
  options[:AWS_access_key_id] = ENV['MY_AMAZON_ACCESS_KEY']
  options[:AWS_secret_key] = ENV['MY_AMAZON_KEY']
end

# amazon/ecs wrapper
class AmazonItem
  def self.search(keyword)
    Amazon::Ecs.item_search(keyword, item_page: 1, country: 'jp').items.map do |item|
      {
        ASIN: item.get('ASIN'),
        URL: item.get('DetailPageURL'),
        title: item.get('ItemAttributes/Title'),
        author: item.get('ItemAttributes/Author')
      }
    end
  end
end

p AmazonItem.search('tofle')
