require 'json'
require 'net/http'
require_relative '../helpers/slack_post'

class LWeather
  attr_accessor :reports, :description
  def initialize(description, reports)
    @description = description
    @reports = reports
  end

  def slack
    text = self.description
    text += "\n----------\n"
    for w in self.reports
      text += "#{w[:date]}: #{w[:telop]}, 最低気温 #{w[:min]}°C 最高気温 #{w[:max]}°C\n"
    end

    slack_post(text, "Weather Report", "#general")
  end


  # class methods
  def self.report
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

    return self.new(description, weather_reports)
  end
end
