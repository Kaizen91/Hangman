
class Game
    attr_accessor :wrong_answers, :secret_word, :code, :guessed_letters, :wordlist
    def initialize
       
        @code = choose_random_word
        @secret_word = secret_word
        @guessed_letters = []
        @wrong_answers = 0
        
        
    end


    def any_letters?(guess)
        @code.include?(guess) ? true : false
    end


    def choose_random_word
        words = File.readlines('wordlist.txt')
        word = " "
        until (word.length <= 11 && word.length >= 5)
          word = words[rand(words.length)].chomp.upcase
        end
        word
    end

    def guess_wrong
        @wrong_answers += 1
    end

    def display_letters
            @guessed_letters.each do |guess|
                @code.split("").each_with_index do |letter, index|
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
        
        @code.length.times do
            @secret_word.push("_")
        end
        @secret_word
    end
end