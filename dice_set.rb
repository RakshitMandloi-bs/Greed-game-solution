class DiceSet
  def roll(n)
    Array.new(n) { rand(1..6) }
  end
end
