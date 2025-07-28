class Player
  attr_reader :name, :total_score
  attr_accessor :in_game

  def initialize(name)
    @name = name
    @total_score = 0
    @in_game = false
  end

  def add_score(score)
    if in_game
      @total_score += score
    elsif score >= 300
      @in_game = true
      @total_score += score
    end
  end
end
