def roll_dice(n)
  Array.new(n) { rand(1..6) }
end
require_relative 'player'

class Game
  # Calculates the score and returns both the score and the scoring dice
  def score(dice)
    counts = Hash.new(0)
    dice.each { |value| counts[value] += 1 }

    result = 0
    scoring_dice = []

    # Handle triples
    (1..6).each do |num|
      if counts[num] >= 3
        result += (num == 1) ? 1000 : num * 100
        3.times { scoring_dice << num }
        counts[num] -= 3
      end
    end

    # Handle remaining 1s and 5s
    if counts[1] > 0
      result += counts[1] * 100
      counts[1].times { scoring_dice << 1 }
    end
    if counts[5] > 0
      result += counts[5] * 50
      counts[5].times { scoring_dice << 5 }
    end

    [result, scoring_dice]
  end
  FINAL_SCORE = 3000

  def initialize(player_count)
    @players = Array.new(player_count) { |i| Player.new("Player #{i + 1}") }
    @in_game_flags = Array.new(player_count, false)
    @final_round_triggered = false
    @final_trigger_index = nil
  end

  def play
    turn = 1

    # Main Game Loop
    loop do
      puts "\nTurn #{turn}:\n" + "--------"

      @players.each_with_index do |player, index|
        puts "\n#{player.name} rolls: #{initial_roll = roll_dice(5).join(', ')}"
        turn_score = take_turn(player, initial_roll)

        if player.total_score >= FINAL_SCORE && !@final_round_triggered
          @final_round_triggered = true
          @final_trigger_index = index
          puts "\n#{player.name} has reached #{FINAL_SCORE}! Final round begins!"
          break
        end
      end

      break if @final_round_triggered
      turn += 1
    end

    # Final Round
    puts "\nFinal Round:\n" + "------------"

    @players.each_with_index do |player, index|
      next if index == @final_trigger_index
      puts "\n#{player.name} rolls: #{initial_roll = roll_dice(5).join(', ')}"
      take_turn(player, initial_roll)
    end

    winner = @players.max_by(&:total_score)
    puts "\n🏆 #{winner.name} wins with #{winner.total_score} points!"
  end

  private

  def take_turn(player, initial_roll)
    dice = initial_roll.split(', ').map(&:to_i)
    round_score = 0
    player_index = @players.index(player)

    loop do
      current_score, scoring_dice = score(dice)
      if current_score == 0
        puts "Score in this round: 0"
        puts "Total score: #{player.total_score}"
        return 0
      end

      round_score += current_score
      non_scoring_dice = dice - scoring_dice

      puts "Score in this round: #{round_score}"
      puts "Total score: #{player.total_score}"

      if non_scoring_dice.empty?
        puts "All dice scored! You may roll all 5 dice again."
        dice = roll_dice(5)
        puts "#{player.name} rolls: #{dice.join(', ')}"
        next
      end

      plural = non_scoring_dice.size == 1 ? "dice" : "dices"
      print "Do you want to roll the non-scoring #{non_scoring_dice.size} #{plural}? (y/n): "
      answer = gets.strip.downcase
      break unless answer == 'y'

      dice = roll_dice(non_scoring_dice.size)
      puts "#{player.name} rolls: #{dice.join(', ')}"
    end

    # Only add score if player is already in game, or this round gets them in
    if @in_game_flags[player_index]
      player.add_to_score(round_score)
    elsif round_score >= 300
      @in_game_flags[player_index] = true
      player.add_to_score(round_score)
    end
    round_score
  end

  # get_scoring_dice is now merged into score method
end
