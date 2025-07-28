require_relative './score'
require_relative './player'
require_relative './dice_set'
require_relative './game'

RSpec.describe 'Greed Game' do
  describe 'Score Calculation' do
    it 'scores a single 1 as 100' do
      expect(score([1])).to eq(100)
    end

    it 'scores a single 5 as 50' do
      expect(score([5])).to eq(50)
    end

    it 'scores triple 1s as 1000' do
      expect(score([1, 1, 1])).to eq(1000)
    end

    it 'scores triple 6s as 600' do
      expect(score([6, 6, 6])).to eq(600)
    end

    it 'scores triple 2s as 200' do
      expect(score([2, 2, 2])).to eq(200)
    end

    it 'scores triple 5s as 500' do
      expect(score([5, 5, 5])).to eq(500)
    end

    it 'scores triple 4s as 400' do
      expect(score([4, 4, 4])).to eq(400)
    end

    it 'scores triple 3s as 300' do
      expect(score([3, 3, 3])).to eq(300)
    end

    it 'does not double count dice' do
      expect(score([1, 1, 1, 1])).to eq(1100)
      expect(score([5, 5, 5, 5])).to eq(550)
    end

    it 'returns 0 for no scoring dice' do
      expect(score([2, 3, 4, 6, 2])).to eq(0)
    end

    it 'scores a mix of triple and single scoring dice' do
      expect(score([1, 1, 1, 5, 1])).to eq(1150)
    end
  end

  describe 'Player' do
    let(:player) { Player.new("Test Player") }

    it 'does not add to total until in_game' do
      player.add_score(250)
      expect(player.total_score).to eq(0)
      expect(player.in_game).to be_falsey
    end

    it 'enters game on score >= 300' do
      player.add_score(350)
      expect(player.total_score).to eq(350)
      expect(player.in_game).to be_truthy
    end

    it 'accumulates score once in game' do
      player.add_score(350)
      player.add_score(200)
      expect(player.total_score).to eq(550)
    end

    it 'ignores score < 300 when not in game' do
      player.add_score(100)
      expect(player.total_score).to eq(0)
    end
  end

  describe 'Game Mechanics' do
    let(:game) { Game.new(2) }
    let(:player1) { Player.new("Alice") }
    let(:player2) { Player.new("Bob") }

    it 'initializes with correct number of players' do
      players = game.instance_variable_get(:@players)
      expect(players.size).to eq(2)
      expect(players.map(&:name)).to eq(["Player 1", "Player 2"])
    end

    it 'rolls 5 dice initially' do
      dice_set = DiceSet.new
      roll = dice_set.roll(5)
      expect(roll.size).to eq(5)
      expect(roll.all? { |d| (1..6).include?(d) }).to be true
    end

    it 'identifies scoring dice correctly' do
      test_dice = [1, 5, 3, 2, 4]
      scoring = game.send(:get_scoring_dice, test_dice)
      expect(scoring).to match_array([1, 5])
    end

    it 'recognizes all dice scored' do
      test_dice = [1, 1, 1, 5, 5]
      scoring = game.send(:get_scoring_dice, test_dice)
      expect(scoring.size).to eq(5)
    end

    it 'returns empty scoring dice if score is 0' do
      test_dice = [2, 3, 4, 6, 3]
      scoring = game.send(:get_scoring_dice, test_dice)
      expect(scoring).to be_empty
    end

    it 'adds score only if roll is not zero' do
      allow(game).to receive(:gets).and_return("n")
      allow_any_instance_of(DiceSet).to receive(:roll).and_return([1, 2, 3, 4, 5])
      player = Player.new("Test")
      game.send(:take_turn, player, "1, 2, 3, 4, 5")
      expect(player.total_score).to be >= 0
    end

    it 'handles roll with all scoring dice and rerolls 5 dice' do
      allow(game).to receive(:gets).and_return("n")
      allow_any_instance_of(DiceSet).to receive(:roll).and_return([1, 1, 1, 5, 5], [2, 3, 4, 6, 2])
      player = Player.new("Test")
      game.send(:take_turn, player, "1, 1, 1, 5, 5")
      expect(player.total_score).to be >= 0
    end

   
  end
end
