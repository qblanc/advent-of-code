require_relative "puzzle_solver"

class Day10 < PuzzleSolver

  def first_result
    gather_trailheads_coordinates
    search_perfect_hiking_trails

    @number_of_valid_trailheads
  end

  def second_result
    @total_hiking_trails
  end

  private

  def search_perfect_hiking_trails
    @number_of_valid_trailheads = 0
    @total_hiking_trails = 0
    trailheads_coordinates.each do |x, y|
      possible_paths.clear
      possible_paths[0] << [x, y]
      (1..9).to_a.each do |next_trail_value|
        search_for_next_trail_section(next_trail_value)
        break if possible_paths[next_trail_value].empty?

      end
      @number_of_valid_trailheads += possible_paths[9].uniq.length
      @total_hiking_trails += possible_paths[9].length
    end
  end

  def possible_paths
    @possible_paths ||= Hash.new { |h, k| h[k] = [] }
  end

  def search_for_next_trail_section(value)
    possible_paths[value - 1].each do |x, y|
      directions.each do |a, b|
        test_x = x + a
        test_y = y + b
        next if out_of_bounds?(test_x, test_y)

        test_section = lines[test_x][test_y]
        possible_paths[value] << [test_x, test_y] if test_section == value
      end
    end
  end

  def out_of_bounds?(x, y)
    x < 0 || x > max_index || y < 0 || y > max_index
  end

  def directions
    [[0, 1], [0, -1], [1, 0], [-1, 0]]
  end

  def gather_trailheads_coordinates
    lines.each_with_index do |arr, arr_i|
      arr.each_with_index do |n, i|
        trailheads_coordinates << [arr_i, i] if n == 0
      end
    end
  end

  def trailheads_coordinates
    @trailheads_coordinates ||= []
  end


  def max_index
    @max_index ||= @input.length - 1
  end

  def lines
    @input.map{ |line| line.chars.map(&:to_i) }
  end
end

Day10.solve
