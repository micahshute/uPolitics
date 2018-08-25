ENV['SINATRA_ENV'] ||= "development"
APP_ROOT = File.dirname(__FILE__)
Bundler.setup
Bundler.require(:default, ENV['SINATRA_ENV'])

ActiveRecord::Base.establish_connection(
    :adapter => "sqlite3",
    :database => "db/#{ENV['SINATRA_ENV']}.sqlite"
)
require 'open-uri'
require_relative './secrets'
require_relative '../app/models/concerns/findable'
require_relative '../app/models/concerns/slugify'
require_all 'app'
