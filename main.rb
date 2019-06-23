require 'sinatra'
require 'sinatra/reloader' if development?
require_relative 'lib/hangman'

enable :sessions

get '/' do 
    erb :index
end