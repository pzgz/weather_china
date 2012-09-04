# -*- encoding : utf-8 -*-
require 'open-uri'
require 'active_record'

class WeatherChina

  def initialize(city_id, options={})
    @city_id = city_id
    @options = options
  end

  def refresh
    # http://www.weather.com.cn/data/sk/101010100.html
    @current = parse_json(open("http://www.weather.com.cn/data/sk/#{@city_id}.html").read)["weatherinfo"] rescue {}
    # http://m.weather.com.cn/data/101010100.html
    @forecast = parse_json(open("http://m.weather.com.cn/data/#{@city_id}.html").read)["weatherinfo"] rescue {}
  end

  def current
    refresh unless (@current and @forecast)
    {
      condition: @forecast.fetch('weather1', nil),
      temp: @current.fetch('temp', nil),
      humidity: @current.fetch('SD', nil),
      icon: wrap_icon(@forecast.fetch('img_single', nil)),
      wind: "#{@current.fetch('WD')}#{@current.fetch('WS')}",
      time: @current.fetch('time', nil)
    } unless (@current.empty? or @forecast.empty?)
  end

  def forecast
    forecasts = []
    (1..6).each do |i|
      temp = @forecast.fetch("temp#{i}", '')
      temps = temp.split '~'
      forecasts << {
        index: i,
        condition: @forecast.fetch("weather#{i}", nil),
        wind: @forecast.fetch("wind#{i}", nil),
        icon_1: wrap_icon(@forecast.fetch("img#{i * 2 -1}", nil)),
        icon_2: wrap_icon(@forecast.fetch("img#{i * 2}", nil)),
        icon_title_1: @forecast.fetch("img_title#{i * 2 - 1}", nil),
        icon_title_2: @forecast.fetch("img#{i * 2}", nil) === '99' ? nil : @forecast.fetch("img_title#{i * 2}", nil),
        temp: temp,
        temp_high: temps.empty? ? '' : temps[0],
        temp_low: temps.empty? ? '' : temps[1]
      }
    end unless @forecast.empty?
    forecasts
  end

  private

  def parse_json(data)
    ActiveSupport::JSON.decode(data)
  end

  def wrap_icon(icon_string)
    "http://m.weather.com.cn/img/b#{icon_string}.gif" unless icon_string === '99'
  end
end
