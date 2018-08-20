ENV['SINATRA_ENV'] ||= "development"

Bundler.setup
Bundler.require(:default, ENV['SINATRA_ENV'])

ActiveRecord::Base.establish_connection(
    :adapter => "sqlite3",
    :database => "db/#{ENV['SINATRA_ENV']}.sqlite"
)

require_relative './secrets'
require_all 'app'
