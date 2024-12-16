require_relative "puzzle_solver"

class Day8 < PuzzleSolver
  def first_result
    gather_antinode_coordinates
    @antinodes_coordinates.compact.uniq.count
  end

  def second_result
    gather_antinode_coordinates(with_resonant_harmonics: true)
    (@antinodes_coordinates + antennas_list.values.flatten(1)).compact.uniq.count
  end

  private

  def gather_antinode_coordinates(with_resonant_harmonics: false)
    @antinodes_coordinates = []

    antennas_list.each_value do |antennas_coordinates|
      antennas_coordinates.permutation(2).each do |antenna_1, antenna_2|
        compute_antinodes_coordinates(antenna_1, antenna_2, with_resonant_harmonics:)
      end
    end
  end

  def compute_antinodes_coordinates(antenna_coordinates, other_antenna_coordinates, with_resonant_harmonics: false)
    x1, y1 = antenna_coordinates
    x2, y2 = other_antenna_coordinates

    loop do
      antinode_x, antinode_y = compute_antinode_coordinates(x1, y1, x2, y2)
      break if antinode_x < 0 || antinode_y < 0 || antinode_x >= grid_length || antinode_y >= grid_length

      @antinodes_coordinates << [antinode_x, antinode_y]
      break unless with_resonant_harmonics

      x2, y2 = x1, y1
      x1, y1 = antinode_x, antinode_y
    end
  end

  def compute_antinode_coordinates(x1, y1, x2, y2)
    [x1 + (x1 - x2), y1 + (y1 - y2)]
  end

  def antennas_list
    @antennas_list ||= gather_antennas_coordinates
  end

  def grid_length
    @grid_length ||= @input.length
  end

  def gather_antennas_coordinates
    antennas_list = Hash.new { |hash, key| hash[key] = [] }
    @input.each_with_index do |line, line_index|
      line.chars.each_with_index do |point, point_index|
        next if point == "."

        antennas_list[point] << [line_index, point_index]
      end
    end
    antennas_list
  end
end

Day8.solve
