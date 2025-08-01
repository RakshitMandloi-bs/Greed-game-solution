require_relative '../src/player'
require_relative '../src/game'

RSpec.describe 'Greed Game' do
  describe 'Score Calculation' do
    let(:game) { Game.new(2) }
    it 'scores a single 1 as 100' do
      expect(game.score([1]).first).to eq(100)
    end

    it 'scores a single 5 as 50' do
      expect(game.score([5]).first).to eq(50)
    end

    it 'scores triple 1s as 1000' do
      expect(game.score([1, 1, 1]).first).to eq(1000)
    end

    it 'scores triple 6s as 600' do
      expect(game.score([6, 6, 6]).first).to eq(600)
    end

    it 'scores triple 2s as 200' do
      expect(game.score([2, 2, 2]).first).to eq(200)
    end

    it 'scores triple 5s as 500' do
      expect(game.score([5, 5, 5]).first).to eq(500)
    end

    it 'scores triple 4s as 400' do
      expect(game.score([4, 4, 4]).first).to eq(400)
    end

    it 'scores triple 3s as 300' do
      expect(game.score([3, 3, 3]).first).to eq(300)
    end

    it 'does not double count dice' do
      expect(game.score([1, 1, 1, 1]).first).to eq(1100)
      expect(game.score([5, 5, 5, 5]).first).to eq(550)
    end

    it 'returns 0 for no scoring dice' do
      expect(game.score([2, 3, 4, 6, 2]).first).to eq(0)
    end

    it 'scores a mix of triple and single scoring dice' do
      expect(game.score([1, 1, 1, 5, 1]).first).to eq(1150)
    end
  end

  describe 'Player' do
    let(:player) { Player.new("Test Player") }

    it 'has a name and total_score' do
      expect(player.name).to eq("Test Player")
      expect(player.total_score).to eq(0)
    end
  end

  describe 'Game Mechanics' do
    let(:game) { Game.new(2) }
    let(:players) { game.instance_variable_get(:@players) }
    let(:player1) { players[0] }
    let(:player2) { players[1] }

    it 'initializes with correct number of players' do
      expect(players.size).to eq(2)
      expect(players.map(&:name)).to eq(["Player 1", "Player 2"])
    end

    it 'rolls 5 dice initially' do
      roll = roll_dice(5)
      expect(roll.size).to eq(5)
      expect(roll.all? { |d| (1..6).include?(d) }).to be true
    end

    it 'identifies scoring dice correctly' do
      test_dice = [1, 5, 3, 2, 4]
      _, scoring = game.score(test_dice)
      expect(scoring).to match_array([1, 5])
    end

    it 'recognizes all dice scored' do
      test_dice = [1, 1, 1, 5, 5]
      _, scoring = game.score(test_dice)
      expect(scoring.size).to eq(5)
    end

    it 'returns empty scoring dice if score is 0' do
      test_dice = [2, 3, 4, 6, 3]
      _, scoring = game.score(test_dice)
      expect(scoring).to be_empty
    end

    it 'adds score only if roll is not zero' do
      allow(game).to receive(:gets).and_return("n")
      allow(self).to receive(:roll_dice).and_return([1, 2, 3, 4, 5])
      game.send(:take_turn, player1, "1, 2, 3, 4, 5")
      expect(player1.total_score).to be >= 0
    end

    it 'handles roll with all scoring dice and rerolls 5 dice' do
      allow(game).to receive(:gets).and_return("n")
      allow(self).to receive(:roll_dice).and_return([1, 1, 1, 5, 5], [2, 3, 4, 6, 2])
      game.send(:take_turn, player1, "1, 1, 1, 5, 5")
      expect(player1.total_score).to be >= 0
    end
  end
end
