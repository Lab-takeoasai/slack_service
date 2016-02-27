require 'sinatra'
require 'sinatra/reloader'

require_relative 'models/hbookmark'
require_relative 'models/LWeather'

get '/' do
  @title = 'main'

  erb :index
end

get '/weather' do
  @title = 'weather'

  LWeather.report.slack

  erb :index
end

get '/hatena' do
  @title = 'hatena bookmark'

  HBookmark.stock_by_tag('ライフハック')
  HBookmark.unslacked.first.slack

  erb :index
end
