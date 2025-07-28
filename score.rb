def score(dice)
  counts = Hash.new(0)
  dice.each { |value| counts[value] += 1 }

  result = 0

  # Handle triples
  (1..6).each do |num|
    if counts[num] >= 3
      result += (num == 1) ? 1000 : num * 100
      counts[num] -= 3
    end
  end

  # Handle remaining 1s and 5s
  result += counts[1] * 100
  result += counts[5] * 50

  result
end
