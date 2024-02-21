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
    @attempts > MAX_ATTEMPTS
  end

  def play
    fetch_word_from_file
    @guess = Array.new(@secret_word.length,"_")
    display
    puts "Enter any letter from a to z"
    letter = gets.chomp
    # until game_over?
    # end
  end

  def display
    puts @guess.join(" ")
  end

end


game = Game.new
game.play
