require 'net/http'
require 'uri'
require 'json'
require_relative 'helpers/slack_post'


# Weather Report Service livedoor: 130010=Tokyo
uri = URI.parse('http://weather.livedoor.com/forecast/webservice/json/v1?city=130010')
json = JSON.parse(Net::HTTP.get(uri))

description = json["description"]["text"].gsub("\n\n", "\n")
weather_reports = []
for day in json["forecasts"]
  weather = {}
  weather[:date] = day["dateLabel"]
  weather[:telop] = day["telop"]
  weather[:min] = day["temperature"]["min"].nil? ? "-" : day["temperature"]["min"]["celsius"]
  weather[:max] = day["temperature"]["max"].nil? ? "-" : day["temperature"]["max"]["celsius"]
  weather_reports << weather
end

description += "\n----------\n"
for w in weather_reports
  description += "#{w[:date]}: #{w[:telop]}, 最低気温 #{w[:min]}°C 最高気温 #{w[:max]}°C\n"
end


# post
slack_post(description, "Weather Report", "#general")
