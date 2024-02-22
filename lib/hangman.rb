require 'yaml'

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
    if @secret_word.empty?
      fetch_word_from_file
      @guess = Array.new(@secret_word.length, "_")
    end
    display
    until game_over?
      puts "Enter your best guess or type 'save' to save the game:"
      input = gets.chomp.downcase
      if input == 'save'
        save_game
        puts "Game saved!"
        next
      end
      @attempts += 1
      if is_single?(input)
        place_letters(input)
      else
        is_correct_word?(input)
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

  def save_game
    File.open('./saved_game.yml', 'w') { |file| file.write(YAML.dump(self)) }
  end

  def self.load_game
    YAML.safe_load(File.read('./saved_game.yml'), permitted_classes: [Game])
  end

end

def start_game
  puts "Welcome to the Hangman Game!"
  puts "Type 'load' to load a saved game or press Enter to start a new game:"
  choice = gets.chomp.downcase
  if choice == 'load'
    game = Game.load_game
  else
    game = Game.new
  end
  game.play
end

start_game
