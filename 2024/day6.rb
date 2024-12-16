require_relative "puzzle_solver"

class Day6 < PuzzleSolver
  DIRECTIONS_WHEEL = { "^" => ">", ">" => "v", "v" => "<", "<" => "^" }
  MOVES = {
    "^" => [0, -1],
    ">" => [1, 0],
    "v" => [0, 1],
    "<" => [-1, 0]
  }

  def first_result
    initiate_guard_path_predictor
    predict_guard_path(position_collector: true)
    @guard_positions.count
  end

  def second_result
    @guard_positions.delete([starting_point_index, starting_line_index])
    @guard_positions
      .select { |coordinates| test_obstruction_for(coordinates) }
      .count
  end

  private

  def initiate_guard_path_predictor
    @y = starting_line_index
    @x = starting_point_index
    @guard_positions = Set.new
    @guard_direction = @input[@y][@x]
    @test_map = @input.map(&:dup)
  end

  def predict_guard_path(position_collector: false, loop_detector: false)
    while @y < @input.length && @y >= 0 && @x < @input[0].length && @x >= 0
      record_guard_position if position_collector
      print_guard_position
      change_guard_direction if next_guard_position == "#"
      break "loop detected" if loop_detector && loop_detected

      change_guard_position
    end
  end

  def test_obstruction_for(coordinates)
    initiate_guard_path_predictor
    add_obstruction(coordinates)
    return true if predict_guard_path(loop_detector: true) == "loop detected"
  end

  def add_obstruction(coordinates)
    @test_map[coordinates[1]][coordinates[0]] = "#"
  end

  def record_guard_position
    @guard_positions.add([@x, @y])
  end

  def print_guard_position
    @test_map[@y][@x] = @guard_direction
  end

  def loop_detected
    @guard_direction == next_guard_position
  end

  def change_guard_position
    @x += MOVES[@guard_direction][0]
    @y += MOVES[@guard_direction][1]
  end

  def next_guard_position
    @test_map[@y + MOVES[@guard_direction][1]]&.[](@x + MOVES[@guard_direction][0])
  end

  def change_guard_direction
    @guard_direction = DIRECTIONS_WHEEL[@guard_direction] while next_guard_position == "#"
  end

  def starting_point_index
    @starting_point_index ||= @input[starting_line_index].index(/[<>^v]/)
  end

  def starting_line_index
    @starting_line_index ||= @input.find_index { |line| line.match(/[<>^v]/) }
  end
end

Day6.solve
