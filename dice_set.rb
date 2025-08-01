
# Simple function to roll n six-sided dice
def roll_dice(n)
  Array.new(n) { rand(1..6) }
end
