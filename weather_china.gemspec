# -*- encoding: utf-8 -*-
require File.expand_path('../lib/weather_china/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Leon Guan"]
  gem.email         = ["leon.guan@gmail.com"]
  gem.description   = "Simple gem to get weather information from www.weather.com.cn, supposed to be used in China"
  gem.summary       = "Get weather infomation from www.weather.com.cn"
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "weather_china"
  gem.require_paths = ["lib"]
  gem.version       = WeatherChina::VERSION
end
