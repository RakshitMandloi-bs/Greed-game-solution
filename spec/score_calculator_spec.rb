require_relative '../src/score_calculator'

describe ScoreCalculator do
  describe '.score' do
    it 'scores a single 1 as 100' do
      expect(ScoreCalculator.score([1]).first).to eq(100)
    end

    it 'scores a single 5 as 50' do
      expect(ScoreCalculator.score([5]).first).to eq(50)
    end

    it 'scores triple 1s as 1000' do
      expect(ScoreCalculator.score([1, 1, 1]).first).to eq(1000)
    end

    it 'scores triple 6s as 600' do
      expect(ScoreCalculator.score([6, 6, 6]).first).to eq(600)
    end

    it 'scores triple 2s as 200' do
      expect(ScoreCalculator.score([2, 2, 2]).first).to eq(200)
    end

    it 'scores triple 5s as 500' do
      expect(ScoreCalculator.score([5, 5, 5]).first).to eq(500)
    end

    it 'scores triple 4s as 400' do
      expect(ScoreCalculator.score([4, 4, 4]).first).to eq(400)
    end

    it 'scores triple 3s as 300' do
      expect(ScoreCalculator.score([3, 3, 3]).first).to eq(300)
    end

    it 'does not double count dice' do
      expect(ScoreCalculator.score([1, 1, 1, 1]).first).to eq(1100)
      expect(ScoreCalculator.score([5, 5, 5, 5]).first).to eq(550)
    end

    it 'returns 0 for no scoring dice' do
      expect(ScoreCalculator.score([2, 3, 4, 6, 2]).first).to eq(0)
    end

    it 'scores a mix of triple and single scoring dice' do
      expect(ScoreCalculator.score([1, 1, 1, 5, 1]).first).to eq(1150)
    end
  end
end
