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
    
    #looks to see if a letter was guessed
    #if !session[:game].code.split(//).any?(/[a-z][A-Z]/) then redirect to("/game") end

    #looks to see if the letter has already been guessed or if the guess is correct length
    if (!session[:game].guessed_letters.include?(guessed_letter) && guessed_letter.length == 1)
        if session[:game].any_letters?(guessed_letter)
            session[:game].display_letters
            session[:game].add_to_guessed_letters(guessed_letter)
        else   
            session[:game].guess_wrong
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
