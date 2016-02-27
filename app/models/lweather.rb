require 'json'
require 'net/http'
require_relative '../helpers/slack_post'

# gets weather report from livedoor webservice
class LWeather
  LIVEDOOR_BASE_URL = 'http://weather.livedoor.com/forecast/webservice/json/'.freeze

  attr_accessor :reports, :description
  def initialize(description, reports)
    @description = description
    @reports = reports
  end

  def slack
    text = @reports.inject(@description + "\n\n") do |a, w|
      a + "#{w[:date]}: #{w[:telop]}, 最低気温 #{w[:min]}°C 最高気温 #{w[:max]}°C\n"
    end

    slack_post(text, 'Weather Report', '#general')
  end

  # class methods
  def self.report
    uri = URI.parse("#{LIVEDOOR_BASE_URL}v1?city=130010") # 130010 is Tokyo code
    json = JSON.parse(Net::HTTP.get(uri))

    description = json['description']['text'].gsub("\n\n", "\n")
    weather_reports = json['forecasts'].map do |day|
      {
        telop: day['telop'],
        date: day['dateLabel'],
        min: day['temperature']['min'].nil? ? '-' : day['temperature']['min']['celsius'],
        max: day['temperature']['max'].nil? ? '-' : day['temperature']['max']['celsius']
      }
    end

    new(description, weather_reports)
  end
end
