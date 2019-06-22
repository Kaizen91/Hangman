
class Game
    require "yaml"
    attr_accessor :player, :computer, :board, :round
    def initialize
        puts "what's your name?"
        @player = Player.new(gets.chomp.downcase)
        @computer = Computer.new
        @board = Board.new(@computer,@player)
        @round = Round.new(@computer, @board, @player, self)
        start_game

    end

    def start_game
        puts "You have started a new game."
        until is_over?
            @round.play_round
        end
    end

    def is_over?
        if @board.wrong_answers >= 6
            lose()
            return true
        elsif (!@board.secret_word.any?("_"))
            win()
            return true
        else
            false
        end
    end

    def lose
        puts "\nThe word was #{computer.code}. /n/n YOU LOSE"
    end

    def win
        puts "#{player.name} WINS"
    end

    def save_game
        Dir.mkdir("./saved_games/") unless Dir.exists?("/saved_games/")
        puts "Would you like to save the game Y/N"
        if gets.chomp.downcase[0] == "y"
            puts "name your file"
            f_name = gets.chomp.downcase.split(" ").join("_").to_s
            file_name = "saved_games/#{f_name}_#{Time.new.usec}.yaml"
        else
            file_name = "saved_games/#{player.name.downcase}_#{Time.new.usec}.yaml"
        end

        data =  YAML.dump(
            {
                :player_name => player.name,
                :computer_code => computer.code,
                :secret_word => board.secret_word,
                :guessed_letters => board.guessed_letters,
                :wrong_answers =>board.wrong_answers
            }
        )

        File.open(file_name, "w") {|file| file.puts data}

        puts "#{file_name} saved!"
    end

def load_game
    save_file = Dir.open("./saved_games/")
    puts "\n CURRENT SAVES \n"

    Dir.foreach(save_file) do |file| 
        puts "#{file.split(".")[0]} \n "
    end

    puts "\n Which file would you like to load?"
    previous_save = gets.chomp.to_s

    if File.exist?("./saved_games/#{previous_save}.yaml")
        data = YAML.load(File.read("./saved_games/#{previous_save}.yaml"))

        player.name = data[:player_name]
        computer.code = data[:computer_code]
        board.secret_word = data[:secret_word]
        board.wrong_answers = data[:wrong_answers]
        board.guessed_letters = data[:guessed_letters]

        puts "\n\n\n\n #{board.display} \n #{previous_save} uploaded!"
    else
        puts "File not found"
        load_game
    end
end
end

class Player 
    attr_accessor :name, :guess
    def initialize(name)
        @name = name
        @guess = nil
    end

    def guess 
        puts "Give me a letter"
        @guess = [gets.chomp.downcase]
        !@guess.any? (/[a-z][A-Z]/) ? (puts "Only letters please"; guess()) : " "
        @guess[0]
    end

end



class Round
    attr_accessor :computer, :board, :player, :game
    def initialize(computer, board, player, game)
        @board = board
        @player = player
        @computer = computer
        @round_number = 0
        @game = game
    end




    def play_round
        guess = @player.guess

        if (!@board.guessed_letters.include?(guess) && guess.length == 1)
            @computer.any_letters?(guess) ? "" : @board.guess_wrong
            @board.add_to_guessed_letters(guess)
            @board.display
        elsif guess.downcase == "save"
            game.save_game
        elsif guess.downcase == "load"
            game.load_game
        end
    end


end

class Computer
    attr_accessor :wordlist, :code
    def initialize
        @wordlist = File.open("wordlist.txt")
        @code = choose_random_word
    end

    def any_letters?(guess)
        @code.include?(guess) ? true : false
    end


    def choose_random_word 
        random_word = []
        @wordlist.rewind
        @wordlist.each do |word|
            if (word.length >= 5 && word.length <= 12)
                random_word.push(word.downcase)
            end
        end
        random_word = random_word[rand(random_word.length)]
        return random_word
    end
end

class Board
    attr_accessor :wrong_answers, :secret_word, :computer, :guessed_letters, :player
    def initialize(computer, player)
        @player = player
        @computer = computer
        @secret_word = secret_word
        @guessed_letters = []
        @wrong_answers = 0
    end


    def guess_wrong
        @wrong_answers += 1
    end

    def display_letters
            @guessed_letters.each do |guess|
                @computer.code.split("").each_with_index do |letter, index|
                    if guess == letter 
                        @secret_word[index] = guess
                    end
                end
            end
            print  "secret word: #{@secret_word.join()} \n"
    end

    def display
        display_letters
        print "guessed letters: #{@guessed_letters}  \n wrong answers: #{wrong_answers} \n"
    end



    def add_to_guessed_letters(guess)
        @guessed_letters.any?(guess) ? "": @guessed_letters << guess
    end


    def secret_word
        @secret_word = []
        
        @computer.code.length.times do
            @secret_word.push("_")
        end
        @secret_word
    end
end

Game.new
