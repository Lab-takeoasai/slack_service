require 'json'
require 'net/http'

# gets Nicovideo info
# videos = Nicovideo.search('mod')
# videos.each do |v|
#   puts v['title']
# end
class Nicovideo
  BASE_URL = 'http://api.search.nicovideo.jp/api/snapshot/'.freeze

=begin
filters:
type	equal もしくは range
field	フィルタ対象フィールド名
value (equal 指定時のみ)	絞込み条件となる値
from (range 指定時のみ, オプション)	範囲指定の開始指定
to (range 指定時のみ, オプション)	範囲指定の終端指定
include_lower (range 指定時のみ, オプション)	開始指定を含むか否か(省略時含む)
include_upper (range 指定時のみ, オプション)	終端指定を含むか否か(省略時含む)

sort_by:
last_comment_time	コメントが新しい/古い順
view_counter	再生数が多い/少ない順
start_time	投稿日時が新しい/古い順
mylist_counter	マイリスト数が多い/少ない順
comment_counter	コメント数が多い順/少ない順
length_seconds	再生時間が長い順/短い順

=end
  def self.search_json(keyword)
    {
      query: keyword,
      service: ['video'],
      search: ['tags_exact'],
      filters: [],
      join: %w('cmsid title description tags start_time thumbnail_url comment_counter mylist_counter length_seconds view_counter'),
      sort_by: 'view_counter',
      from: 0,
      order: 'desc',
      size: 10,
      issuer: 'slack_service_test'
    }.to_json
  end

  def self.search(keyword)
    # post json to API
    uri = URI.parse(BASE_URL)
    body = Net::HTTP.start(uri.host).post(uri.path, search_json(keyword)).body

    # JSON.parse => error
    body.scan(/\{"_rowid":.*?\}/).map do |e|
      keys_and_values = e.scan(/"(.+?)":(.+?)[,}]/x)
      Hash[*keys_and_values.flatten]
    end
  end
end
