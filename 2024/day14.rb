require_relative "puzzle_solver"

class Day14 < PuzzleSolver
  GRID_X_SIZE = 101.freeze
  GRID_Y_SIZE = 103.freeze

  def first_result
    predict_robots_positions(number_of_seconds: 100)
    robots_per_quadrant.inject(:*)
  end

  def second_result
    # we assume the picture is custom made, therefore there is no overlapping robot
    reinitialize_robot_list
    index = 0
    loop do
      predict_robots_positions(number_of_seconds: 1)
      robot_positions = robots_list.map { |_, robot| robot[:position] }
      break index if robot_positions.length == robot_positions.uniq.length

      index += 1
    end
  end

  private

  def robots_per_quadrant
    robots_per_quadrant = [0, 0, 0, 0]
    robots_list.each do |_, robot|
      quadrant_index = quadrant_index(robot[:predicted_position])
      next if quadrant_index.nil?

      robots_per_quadrant[quadrant_index] += 1
    end
    robots_per_quadrant
  end

  def predict_robots_positions(number_of_seconds:)
    robots_list.each do |_, robot|
      robot[:position] = robot[:predicted_position] unless robot[:predicted_position].nil?
      robot[:predicted_position] = predict_robot_position(robot[:position], robot[:velocity], number_of_seconds)
    end
  end

  def predict_robot_position(initial_position, velocity, seconds)
    x, y = initial_position
    x_velocity, y_velocity = velocity

    [predicted_position("x", x, x_velocity, seconds), predicted_position("y", y, y_velocity, seconds)]
  end

  def predicted_position(axis, x, velocity, seconds)
    grid_size = Day14.const_get("GRID_#{axis.upcase}_SIZE")
    x + seconds * velocity - (((x + seconds * velocity) / grid_size) * grid_size)
  end

  def quadrant_index(position)
    x, y = position
    case x
    when (0...GRID_X_SIZE / 2)
      case y
      when (0...GRID_Y_SIZE / 2)
        0
      when (GRID_Y_SIZE.ceildiv(2)...GRID_Y_SIZE)
        1
      end
    when (GRID_X_SIZE.ceildiv(2)...GRID_X_SIZE)
      case y
      when (0...GRID_Y_SIZE / 2)
        2
      when (GRID_Y_SIZE.ceildiv(2)...GRID_Y_SIZE)
        3
      end
    end
  end

  def reinitialize_robot_list
    @robots_list = collect_robots_list
  end

  def robots_list
    @robots_list ||= collect_robots_list
  end

  def collect_robots_list
    robots_list = Hash.new
    @input.each_with_index do |robot, index|
      infos = robot.scan(/p=(-?\d+),(-?\d+) v=(-?\d+),(-?\d+)/).flatten!(1).map(&:to_i)
      robots_list[index] = { position: [infos[0], infos[1]], velocity: [infos[2], infos[3]]}
    end
    robots_list
  end
end

Day14.solve
