require "yaml"
# intro to game code
puts''
puts 'Welcome to my Hangman Game'
puts''
puts 'Guess a letter to unravel the word'
puts''
puts'You have 10 guesses available to use'
puts''
sleep(4)
puts'If you are not able to correctly guess the word before your 10 tries are used'
sleep(3)
puts'...'
puts''
sleep(3)
puts'well'
puts''
sleep(3)
puts'...'
sleep(3)
puts''
puts'you sure are hung man'
puts''

# code to begin playing game
class Game

  attr_accessor :one_word
  
  def start
    puts'If you would like to play please press 1 or if you would like to open a previously saved game press 2'
    response=gets.chomp()
    if response == '1'
      random_word
    elsif response == '2'
      load_game   
    end
  end
#  code to get random word and to add ____ for random word
  def initialize
    @display 
    @one_word
    @letters= []
    @incorrect = 10
  end
    
  def random_word
    word_choice = []
    list = File.open('./google-10000-english-no-swears.txt')
    list.each do |word|
      word_choice << word if word.length >= 6 && word.length <= 9
    end
    @one_word= word_choice.sample.strip().to_s
    @display = "_" * @one_word.length    
    puts @display
    turn
  end
#  code to get letters to show on page if they are correct or not
  def turn
     until @incorrect === 0 or @one_word==@display do
      puts'Enter in one letter please or type "save" to save'
      input=gets.chomp.downcase().to_s
        valid
        @letters << input
        @incorrect-=1
        update
        winner
      if input == 'save'
        @incorrect +=1
        save_game
      elsif @letters.any?{|char|@one_word.include?(char)}
        puts @display
        puts"Letters you have picked: #{@letters} and you have #{@incorrect} attempts left"
      elsif input != @one_word.split()
        puts @display
        puts"Letters you have picked: #{@letters}"
        puts"You have #{@incorrect} attempts left"
      end
     end
  end
    
  def valid
    until @letters.length >=1 or @letters !=~ /[a-z]/
      puts 'Only enter one letter at a time please that is a-z'
      input=gets.chomp.downcase().to_s
      @incorrect +=1
    if input.include?(@letters)
      puts'You have already entered that letter. Enter a new letter please'
      input=gets.chomp.downcase().to_s
      @incorrect +=1
    else
      turn
    end
    end
  end
  
# code to update display
  def update
    @one_word.split("").each_with_index do|letter,index|
      @display[index] = "#{letter}"if @letters.include?(letter)
    end
  end
# code to save and load previous game
  def save_game
    File.open('saved_game.yml', 'w') { |f| YAML.dump([] << self, f) }
    puts 'Game Saved!'
    exit
  end

  def load_game
    yaml = YAML.load_file('./saved_game.yml')
    'Enter in a letter and the game board will appear'
    @one_word = yaml[0].one_word
    @display = yaml[0].display
    turn=yaml[0].turn
    winner
    play_again
  end

 
  def winner
    if @one_word == @display 
      puts"Congrats on your great escape! The word was #{@one_word}"
      play_again
    elsif @incorrect == 0
      puts"Sorry you were hung. The word was #{@one_word}"
      play_again
    end
  end
end

    
def play_again
  puts"Would you like to play again. Press 1 to play again and 2 to quit"
  decision=gets.chomp()
  if decision == "1"
    start
    initialize
    turn
    winner
  elsif decision == "2"
    puts"Okay, thanks for playing!"
  end
end


game= Game.new
game.start
game.winner


