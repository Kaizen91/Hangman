
class Game
    attr_accessor :wrong_answers, :secret_word, :code, :guessed_letters, :wordlist
    def initialize
       
        @code = choose_random_word
        @secret_word = generate_secret_word
        @guessed_letters = []
        @wrong_answers = 0
           
    end

    def any_letters?(guess)
        guess = guess.upcase
        @code.include?(guess) ? true : false
    end

    def check_guess_format(guess)
        guess = guess.upcase
        if (!guessed_letters.include?(guess) && guess.length == 1  && guess.count("a-zA-Z") > 0)
            return true
        else
            return false
        end
    end

    def add_to_guessed_letters(guess)
        guess = guess.upcase
        if !@guessed_letters.any?(guess) then @guessed_letters << guess end 
    end

    def display_correctly_guessed_letters(guess)
        index_of_correct_guess = @code.split("").each_index.select {|i| puts "i =#{i}" }
        index_of_correct_guess.each { |n|  puts "n = #{n}"}
        puts "#{@secret_word}"
    end

    def display_letters
        @guessed_letters.each do |guess|
            @code.split("").each_with_index do |letter, index|
                puts "#{@code}, #{@guessed_letters}, #{@secret_word}, #{letter}, #{index}"
                if guess.upcase == letter.upcase 
                    @secret_word[index] = guess
                end
                puts "#{@code}, #{@guessed_letters}, #{@secret_word}, #{letter}, #{index}"
            end
        end
    end

    def guess_is_right(guess) 
        add_to_guessed_letters(guess)
        display_letters 
    end

    def guess_wrong(guess)
        @wrong_answers += 1
        add_to_guessed_letters(guess)
    end
 





    def choose_random_word
        words = File.readlines('wordlist.txt')
        word = " "
        until (word.length <= 11 && word.length >= 5)
          word = words[rand(words.length)].chomp.upcase
        end
        word
    end

    def generate_secret_word
        @secret_word = []
        
        @code.length.times do
            @secret_word.push("_")
        end
        @secret_word
    end
end