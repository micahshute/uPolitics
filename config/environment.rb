ENV['SINATRA_ENV'] ||= "development"
APP_ROOT = File.dirname(__FILE__)
Bundler.setup
Bundler.require(:default, ENV['SINATRA_ENV'])

require 'date'
require 'open-uri'
require_relative '../app/models/concerns/findable'
require_relative '../app/models/concerns/slugify'
require_all 'app'
