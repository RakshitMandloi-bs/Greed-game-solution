class ScoreCalculator
  # Calculates the score and returns both the score and the scoring dice
  def self.score(dice)
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
end
