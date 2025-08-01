class Player
  attr_reader :name, :total_score

  def initialize(name)
    @name = name
    @total_score = 0
  end

  def add_to_score(points)
    @total_score += points
  end
end
