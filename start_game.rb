require_relative './game'

puts "🎲 Welcome to Greed Dice Game!"
print "Enter number of players: "
num_players = gets.strip.to_i

if num_players < 2
  puts "You need at least 2 players to play!"
  exit
end

game = Game.new(num_players)
game.play
