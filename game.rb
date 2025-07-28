require_relative 'dice_set'
require_relative 'score'
require_relative 'player'

class Game
  FINAL_SCORE = 3000

  def initialize(player_count)
    @players = Array.new(player_count) { |i| Player.new("Player #{i + 1}") }
    @dice_set = DiceSet.new
    @final_round_triggered = false
    @final_trigger_index = nil
  end

  def play
    turn = 1

    # Main Game Loop
    loop do
      puts "\nTurn #{turn}:\n" + "--------"

      @players.each_with_index do |player, index|
        puts "\n#{player.name} rolls: #{initial_roll = @dice_set.roll(5).join(', ')}"
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
      puts "\n#{player.name} rolls: #{initial_roll = @dice_set.roll(5).join(', ')}"
      take_turn(player, initial_roll)
    end

    winner = @players.max_by(&:total_score)
    puts "\n🏆 #{winner.name} wins with #{winner.total_score} points!"
  end

  private

  def take_turn(player, initial_roll)
    dice = initial_roll.split(', ').map(&:to_i)
    round_score = 0

    loop do
      current_score = score(dice)
      if current_score == 0
        puts "Score in this round: 0"
        puts "Total score: #{player.total_score}"
        return 0
      end

      round_score += current_score
      scoring_dice = get_scoring_dice(dice)
      non_scoring_dice = dice - scoring_dice

      puts "Score in this round: #{round_score}"
      puts "Total score: #{player.total_score}"

      if non_scoring_dice.empty?
        puts "All dice scored! You may roll all 5 dice again."
        dice = @dice_set.roll(5)
        puts "#{player.name} rolls: #{dice.join(', ')}"
        next
      end

      plural = non_scoring_dice.size == 1 ? "dice" : "dices"
      print "Do you want to roll the non-scoring #{non_scoring_dice.size} #{plural}? (y/n): "
      answer = gets.strip.downcase
      break unless answer == 'y'

      dice = @dice_set.roll(non_scoring_dice.size)
      puts "#{player.name} rolls: #{dice.join(', ')}"
    end

    player.add_score(round_score)
    round_score
  end

  def get_scoring_dice(dice)
    counts = Hash.new(0)
    dice.each { |d| counts[d] += 1 }
    result = []

    counts.each do |num, count|
      if count >= 3
        3.times { result << num }
        count -= 3
      end

      if num == 1
        count.times { result << 1 }
      elsif num == 5
        count.times { result << 5 }
      end
    end

    result
  end
end
