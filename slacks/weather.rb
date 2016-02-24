require 'slack'
require 'net/http'
require 'uri'
require 'json'

# Slack configuration
$:.unshift File.dirname(__FILE__)
require "token" # set your $token in ./token.rb
Slack.configure do |config|
  config.token = $token
end


# Weather Report Service livedoor: 130010=Tokyo
uri = URI.parse('http://weather.livedoor.com/forecast/webservice/json/v1?city=130010')
json = JSON.parse(Net::HTTP.get(uri))

description = json["description"]["text"].gsub("\n\n", "\n")
weather_reports = []
for day in json["forecasts"]
  weather = {}
  weather[:date] = day["dateLabel"]
  weather[:telop] = day["telop"]
  weather[:min] = day["temperature"]["min"]["celsius"] unless day["temperature"]["min"].nil?
  weather[:max] = day["temperature"]["max"]["celsius"] unless day["temperature"]["max"].nil?
  weather[:min] = "-" if weather[:min].nil?
  weather[:max] = "-" if weather[:max].nil?
  weather_reports << weather
end

description += "\n----------\n"
for w in weather_reports
  description += "#{w[:date]}: #{w[:telop]}, 最低気温 #{w[:min]}°C 最高気温 #{w[:max]}°C\n"
end


# Post it to my slack
if Slack.auth_test["ok"] then
  Slack.chat_postMessage(text: description, username: 'Weather Report' , channel: '#general')
end
