require 'json'
require 'uri'
require 'net/http'

# gets Ted talk title and description in each language from id
class Ted
  TED_BASE_URL = 'http://www.ted.com/talks/'.freeze

  def initialize(id)
    @id = id
    @title = {}
    @summary = {}
    @desc = {}
  end

  def description(lang)
    if @desc[lang].nil?
      uri = URI.parse("#{TED_BASE_URL}subtitles/id/#{@id}/lang/#{lang.to_s}")
      json = JSON.parse(Net::HTTP.get(uri))
      @desc[lang] = json['captions'].map { |a| a['content'] }.join("\n")
    end
    @desc[lang]
  end

  def load_title(lang)
    uri = URI.parse("#{TED_BASE_URL}titles/id/#{@id}/lang/#{lang.to_s}")
    json = JSON.parse(Net::HTTP.get(uri))
    @title[lang] = json['response']['altheadline']
    @summary[lang] = json['response']['tagline']
  end

  def title(lang)
    load_title(lang) if @title[lang].nil?
    @title[lang]
  end

  def summary(lang)
    load_title(lang) if @summary[lang].nil?
    @summary[lang]
  end
end
