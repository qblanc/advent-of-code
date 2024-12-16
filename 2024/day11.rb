require_relative "puzzle_solver"

class Day11 < PuzzleSolver
  def first_result
    initialize_stones_hash
    compute_number_of_stones_after_blink(25)
    total_number_of_stones
  end

  def second_result
    initialize_stones_hash
    compute_number_of_stones_after_blink(75)
    total_number_of_stones
  end

  private

  def total_number_of_stones
    stones_hash.values.sum
  end

  def compute_number_of_stones_after_blink(number_of_blinks)
    number_of_blinks.times do
      stones_hash.clone.each do |key, value|
        increment_stones_hash(key, value)
      end
    end
  end

  def initialize_stones_hash
    stones_hash.clear
    starting_stones.each do |stone|
      stones_hash[stone] += 1
    end
  end

  def increment_stones_hash(stone, number_of_stones)
    if stone.length.even?
      new_stone_1, new_stone_2 = split_string(stone)
      stones_hash[new_stone_1] += number_of_stones
      stones_hash[new_stone_2.to_i.to_s] += number_of_stones
      stones_hash[stone] -= number_of_stones
    elsif stone == "0"
      stones_hash["0"] -= number_of_stones
      stones_hash["1"] += number_of_stones
    else
      stones_hash[(stone.to_i * 2024).to_s] += number_of_stones
      stones_hash[stone] -= number_of_stones
    end
  end

  def split_string(str)
    [str[0, str.size/2], str[str.size/2..-1]]
  end

  def stones_hash
    @stones_hash ||= Hash.new { |h, k| h[k] = 0 }
  end

  def starting_stones
    @starting_stones ||= @input.first.split(" ").dup
  end
end

Day11.solve
