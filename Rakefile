ENV['SINATRA_ENV'] ||= "development"

require_relative './config/environment'
require 'sinatra/activerecord/rake'
require 'pry'
desc 'console testing'
task :console do 
    Pry.start
end