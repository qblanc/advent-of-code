require_relative "puzzle_solver"

class Day4 < PuzzleSolver
  def first_result
    xmas_word_count
  end

  def second_result
    x_mas_count
  end

  private

  def xmas_word_count
    xmas_counter = 0
    x_coordinates_counter.each do |x, y|
      xmas_counter += 1 if @input.dig(x, y + 1) == "M" && @input.dig(x, y + 2) == "A" && @input.dig(x, y + 3) == "S"
      xmas_counter += 1 if y > 2 && @input.dig(x, y - 1) == "M" && @input.dig(x, y - 2) == "A" && @input.dig(x, y - 3) == "S"
      xmas_counter += 1 if @input.dig(x + 1, y) == "M" && @input.dig(x + 2, y) == "A" && @input.dig(x + 3, y) == "S"
      xmas_counter += 1 if x > 2 && @input.dig(x - 1, y) == "M" && @input.dig(x - 2, y) == "A" && @input.dig(x - 3, y) == "S"
      xmas_counter += 1 if x > 2 && @input.dig(x - 1, y + 1) == "M" && @input.dig(x - 2, y + 2) == "A" && @input.dig(x - 3, y + 3) == "S"
      xmas_counter += 1 if y > 2 && @input.dig(x + 1, y - 1) == "M" && @input.dig(x + 2, y - 2) == "A" && @input.dig(x + 3, y - 3) == "S"
      xmas_counter += 1 if x > 2 && y > 2 && @input.dig(x - 1, y - 1) == "M" && @input.dig(x - 2, y - 2) == "A" && @input.dig(x - 3, y - 3) == "S"
      xmas_counter += 1 if @input.dig(x + 1, y + 1) == "M" && @input.dig(x + 2, y + 2) == "A" && @input.dig(x + 3, y + 3) == "S"
    end
    xmas_counter
  end

  def x_coordinates
    @x_coordinates ||= x_coordinates_counter
  end

  def x_coordinates_counter
    x_coordinates = []
    @input.map!(&:chars).each_with_index do |line, horizontal_index|
      line.each_with_index do |letter, vertical_index|
        x_coordinates << [horizontal_index, vertical_index] if letter == "X"
      end
    end
    x_coordinates
  end

  def x_mas_count
    x_mas_counter = 0
    a_coordinates.each do |x, y|
      next if x < 1 || y < 1

      first_pair = [@input.dig(x - 1, y - 1), @input.dig(x + 1, y + 1)]
      second_pair = [@input.dig(x + 1, y - 1), @input.dig(x - 1, y + 1)]
      x_mas_counter += 1 if first_pair.include?("M") && first_pair.include?("S") && second_pair.include?("M") && second_pair.include?("S")
    end
    x_mas_counter
  end

  def a_coordinates
    @a_coordinates ||= a_coordinates_counter
  end

  def a_coordinates_counter
    a_coordinates = []
    @input.each_with_index do |line, horizontal_index|
      line.each_with_index do |letter, vertical_index|
        a_coordinates << [horizontal_index, vertical_index] if letter == "A"
      end
    end
    a_coordinates
  end
end

Day4.solve
