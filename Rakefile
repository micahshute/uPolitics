ENV['SINATRA_ENV'] ||= "development"

require_relative './config/environment'
require 'sinatra/activerecord/rake'

desc 'console testing'
task :console do 
    # Pry.start
    IRB.start(__FILE__)
end