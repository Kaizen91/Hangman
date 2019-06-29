require 'sinatra'
require 'sinatra/reloader' if development?
require_relative 'lib/hangman'


enable :sessions

get '/' do 
    erb :index
end

post '/' do 
    session[:game] = Game.new
    redirect to('/game')
end



get '/game' do 
    erb :game, :locals => {:secret_word => session[:game].secret_word,
                            :wrong_answers => session[:game].wrong_answers,
                            :code => session[:game].code,
                            :guessed_letters => sessions[:game].guessed_letters}
end
