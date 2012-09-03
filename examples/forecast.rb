require File.dirname(__FILE__) + '/../lib/weather_china'
require 'pp'

weather = WeatherChina.new '101020200'
pp weather.current
pp weather.forecast