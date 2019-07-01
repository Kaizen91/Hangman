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
    erb :game, :locals => {:game => session[:game],
        :secret_word => session[:game].secret_word,
        :wrong_answers => session[:game].wrong_answers,
        :code => session[:game].code,
        :guessed_letters => session[:game].guessed_letters}
end

post '/game' do
    guessed_letter = params['guessed_letter']
    
    if session[:game].check_guess_format(guessed_letter)
        if session[:game].any_letters?(guessed_letter)
            session[:game].guess_is_right(guessed_letter)
        else
            session[:game].guess_wrong(guessed_letter)
        end
    else
        redirect to("/game")
    end

    erb :game, :locals => {:game => session[:game],
        :guessed_letters => session[:game].guessed_letters,
        :secret_word => session[:game].secret_word,
        :wrong_answers => session[:game].wrong_answers,
        :code => session[:game].code,
        :guessed_letter => guessed_letter}
end
