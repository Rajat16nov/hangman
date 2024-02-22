class Game

  MAX_ATTEMPTS = 8

  def initialize
    @secret_word = ""
    @attempts = 0
    @guess = []
  end

  def fetch_word_from_file
    file_data = File.read("./google-10000-english-no-swears.txt").split
    file_data_filtered = file_data.select { |word| word.length > 5 && word.length <= 12 }
    @secret_word = file_data_filtered.sample
    puts @secret_word
  end

  def game_over?
    @attempts >= MAX_ATTEMPTS
  end

  def is_alpha?(char)
    char.match?(/[A-Za-z]/)
  end

  def is_single?(char)
    char.length == 1
  end

  def is_won?
    @guess.join("") == @secret_word
  end

  def is_correct_word?(letter)
    if letter == @secret_word
      @guess = letter.split("")
    end
  end

  def place_letters(guessed_letter)
    @secret_word.split("").each_with_index do |letter, index|
      if letter == guessed_letter
        @guess[index] = guessed_letter
      end
    end
  end


  def play
  fetch_word_from_file
  @guess = Array.new(@secret_word.length,"_")
  display
  until game_over?
    letter = ""
    until is_alpha?(letter)
      puts "Enter your best guess!"
      letter = gets.chomp.downcase
    end
    @attempts += 1
    if is_single?(letter)
      place_letters(letter)
    else
      is_correct_word?(letter)
    end
    if is_won?
      puts "Yeah, you guessed it right: #{@secret_word}"
      break
    end
    display
  end
end

  def display
    puts @guess.join(" ")
    attempts_remaining = MAX_ATTEMPTS - @attempts
    if attempts_remaining == 0
      puts "Game Over: The word was #{@secret_word}"
    else
      puts "Attempts remaining: #{attempts_remaining}"
    end
  end

end

game = Game.new
game.play
